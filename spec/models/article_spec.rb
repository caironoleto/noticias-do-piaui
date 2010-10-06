require 'spec_helper'

describe Article do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :text => "value for text",
      :origin_url => "#{Rails.root}/spec/fixtures/180_page_1.html"
      }
  end
  
  before(:each) do
    @domain_valid_attributes = {
      :title => "value for title",
      :url => "http://original-domain.com",
      :feed_url => "#{File.read("spec/fixtures/180_rss.rss")}",
      :nokogiri_search_field => "#texto_materia",
      :nokogiri_time_fields => "span#data,span#data_hora",
      :paragraph_tag => "p"
    }

    domain = Domain.create!(@domain_valid_attributes)
    subject.update_attributes(:domain => domain)
  end
  
  subject do
    Article.new(@valid_attributes)
  end

  it "should create slug after save" do
    subject.save
    subject.slug.should == "value-for-title"
  end
  
  it "should remove www from origin_url" do
    subject.update_attributes(:origin_url => "#{subject.domain.url}/my-article")
    subject.origin_url.should == "#{subject.domain.url}/my-article"
    subject.update_attributes(:origin_url => "#{subject.domain.url}/my-article")
    subject.origin_url.should == "#{subject.domain.url}/my-article"
  end

  it "should complete the origin_url with domain" do
    subject.update_attributes(:origin_url => "/this-is-my-url")
    subject.origin_url.should == "#{subject.domain.url}/this-is-my-url"
    subject.update_attributes(:origin_url => "#{subject.domain.url}/this-is-my-url")
    subject.origin_url.should == "#{subject.domain.url}/this-is-my-url"
  end

  it "should add in DJ when process" do
    lambda {
      subject.process
    }.should change(Delayed::Job, :count).by(1)
  end
  
  describe "named scopes" do
    before(:each) do
      domain = Domain.create!(@domain_valid_attributes)
      @article_invalid = Article.create(@valid_attributes.merge(:published_at => Time.now + 1.hour, :domain => domain))
      @article_valid_1 = Article.create(@valid_attributes.merge(:published_at => Time.now - 10.minutes, :domain => domain))
      @article_valid_2 = Article.create(@valid_attributes.merge(:published_at => Time.now - 1.hour, :domain => domain))
    end

    it "should return all ready article" do
      Article.ready(Time.now).should == [@article_valid_1, @article_valid_2]
    end
  end
  
  describe "process the text" do
    before(:each) do
      subject.domain.update_attributes(:url => Rails.root)
    end
    
    it "should save the text" do
      subject.update_attributes(:origin_url => "#{Rails.root}/spec/fixtures/180_page_1.html")
      subject.process_without_send_later #No send to delayed job
      subject.text.should == "<p>Ao meio-dia desta quinta-feira (12/08), várias pessoas se reuniram com seus guarda-chuvas nas paradas de ônibus pela extensão da Avenida Frei Serafim, Centro de Tereisna, e proporcionaram uma \"sombra de dignidade\" àquelas que já se encontravam lá.</p><p>No primeiro minuto, causou estranheza que cada pessoa abrisse seu guarda-chuva colorido e dividisse sua sombra com quem estava ao lado, mas o Flash Mob em Teresina partiu de uma idéia de chamar atenção para a deficiência dos abrigos e paradas de Trânsito de Teresina.</p><p>O Flash Mob não é uma manifestação comum, como uma passeata, piquete, etc. Em geral são organizados pela internet, com pessoas que nunca se viram pessoalmente ou mesmo que tenham se falado online, com a intenção de fazer uma coisa surreal, insólita e divertida. Esse tipo de manifestação já foi usada como forma de protesto, mas é raro. O maior Flash Mob que se tem notícia foi em um show da banda Black Eyed Peas, em que 20 mil pessoas se reuniram e dançaram a coreografia da música \"I got a feeling\" ao mesmo tempo. A Prefeitura de Teresina tem um projeto, desde a gestão anterior, de novas paradas de ônibus, mas até hoje nunca saiu do papel. Os abrigos para esperar o transporte coletivo são ruins em Teresina e não protegem nem contra o sol e nem contra a chuva.</p><p>OUTRA MANIFESTAÇÃO<br />Outro grupo de jovens se reuniu próximo ao Hiper Bompreço em manifestação paralela ao Flash Mob Teresina. Eles pintaram o rosto, usaram água e guardas-chuvas para alertar as autoridades e principalmente as pessoas, que a cidade não está preparada para a excessiva quantidade de sol. \"Podemos observar isso, quando olhamos para muitas paradas de ônibus da capital, que não são cobertas para abrigar as pessoas\", disse Patrício Oliveira, membro do grupo. Eles fazem ações diferentes. \"O propósito é brincar com os conceitos de sombra e de luz, mostrando os contrastes e como eles precisam um do outro\", afirmou Patricío Oliveira. Esse movimento utilizou um elemento a mais para protestar: a água. </p><p>CONFIRA AQUI AS IMAGENS:</p>"

      subject.update_attributes(:origin_url => "#{Rails.root}/spec/fixtures/180_page_2.html")
      subject.process_without_send_later
      subject.word_processing(subject.text).should == "<p>O Estado do Piauí enquadrou mais um político do Piauí na Lei Complementar 135/2010, a Lei Ficha Limpa. José Néri de Sousa, candidato a deputado estadual, teve o registro de sua candidatura indeferido, pois foi acusado de improbidade administrativa por aplicação irregular de recursos do Fundo de Manutenção e Desenvolvimento do Ensino Fundamental), enquanto prefeito de Picos.</p><p>José Neri de Sousa é o terceiro a ser enquadrado na Ficha Limpa. Judson Barros (PV) e Roncalli Paulo (PSDB), ambos pretensos candidatos a deputado estadual já haviam sido enquadrado na referida lei. Roncalli Paulo por ser acusado de cometer irregularidades insanáveis de improbidade administrativa.</p><p>Ele também teria cometido irregularidades na aplicação de verbas durante a construção da barragem de Castelo. Na época, Roncalli Paulo era funcionário da Defesa Civil Estadual. Já Judson Barros, foi demitido do serviço público por meio de processo administrativo disciplinar, portanto, está inelegível por oito anos, pois o processo foi divulgado no Diário Oficial do Estado em março de 2009.</p><p>SESSÃO<br />Na sessão desta quinta-feira o TRE apreciou 12 Embargos e Declaração no registro de candidaturas de candidatos a cargos eletivos no Piauí nas eleições 2010. Além de José Néri de Sousa, outros três candidatos a deputado estadual tiveram embargos negados.</p><p>VEJA A LISTA DE JULGADOS HOJE<br />INDEFERIDO (EMBARGOS NEGADO)<br />1. JUDSON BARROS - DEPUTADO ESTADUAL<br />2. RAIMUNDO NONATO BONA - DEPUTADO ESTADUAL<br />3. JOSÉ NÉRIDE SOUSA - DEPUTADO FEDERAL<br />4. MARIA LEONORA FERREIRA DE SÁDEFERIDOS (EMBARGOS ACEITOS)<br />1. ANA CRISTINA DA SILVA VERAS - DEPUTADA ESTADUAL<br />2. JORGE DOS SANTOS SOUSA - DEPUTADO ESTADUAL<br />3. CARIOLANDO PEREIRA DE FRANÇA - DEPUTADO ESTADUAL<br />4. MARIA MADALENA NUNES - DEPUTADA FEDERAL<br />5. IANE DE SOUSA MARINHO - DEPUTADO FEDERAL<br />6. WALTER LUSTOSA DE CARVALHO - DEPUTADO ESTADUAL<br />7. ANTONIO WILLAMES BARROS DE MEDEIROS - DEPUTADA FEDERAL</p><p>CONFIRA COMO FOI A COBERTURA DO 180GRAUS AOS JULGAMENTOS NO TRE-PI</p><p>REPÓRTER: Daniel Silva</p>"

      subject.update_attributes(:origin_url => "#{Rails.root}/spec/fixtures/180_page_3.html")
      subject.process_without_send_later
      subject.word_processing(subject.text).should == "<p>O deputado Moraes Souza Filho criticou duramente o médico Solon Reis, candidato a vice-governador na chapa encabeçada pela vereadora Teresa Britto (PV) ao governo do estado. Ele disse que Solon Reis não tem autoridade para falar sobre a situação da saúde pública do estado porque a saúde municipal, em Teresina, é precária e a vereadora Teresa Britto passou vários anos apoiando a gestão tucana, que comandava a prefeitura de Teresina. Moraes Filho chamou Solon de pessimista e disse que as grandes transformações no setor público do estado começaram a acontecer de 2003 para cá. Ele disse que os hospitais públicos do estado são resolutivos e que o governador Wilson Martins está implantando UTI's em vários municípios, inclusive Floriano, e vai entregar 90 ambulâncias nos próximos dias.</p>"
    end
    
    it "after save add published_at" do
      subject.update_attributes(:origin_url => "#{Rails.root}/spec/fixtures/180_page_1.html")
      subject.process_without_send_later
      subject.text.should_not be_empty
      subject.published_at.should be_present
    end
    
    it "should extract the published time" do
      time = "27/08/2010 às 14:46h"
      subject.parse_datetime(time).should == "08/27/2010 14:46"
      time = "27-08-2010 às 14:46h"
      subject.parse_datetime(time).should == "08/27/2010 14:46"
      time = "28/08/10, 07:56"
      subject.parse_datetime(time).should == "08/28/10 07:56"
      time = "28/08/10, 10h:39"
      subject.parse_datetime(time).should == "08/28/10 10:39"
    end
  end
end