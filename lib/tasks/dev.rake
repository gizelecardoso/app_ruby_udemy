namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      #do end = {}
      show_spinner("Apagando BD...") do
        %x(rails db:drop)
      end
      show_spinner("Criando BD...") {%x(rails db:create)}
      show_spinner("Migrando BD...") {%x(rails db:migrate)}
      %x(rails dev:add_coins)
      %x(rails dev:add_mining_types)
    else
      puts "Você não está em modo de desenvolvimento!"
    end
  end

  desc "Cadastra as Moedas"
  task add_coins: :environment do
    show_spinner("Cadastrando Moedas...") do
      coins = [
          {    
            description: "Bitcoin",
            acronym: "BTC",
            url_image: "https://logos-world.net/wp-content/uploads/2020/08/Bitcoin-Emblem.png"
          },
          {   
            description: "Ethereum",
            acronym: "ETH",
            url_image: "https://ethereum.org/static/4b5288012dc4b32ae7ff21fccac98de1/31987/eth-diamond-black-gray.png"
          },
          {
            description: "Dash",
            acronym: "DASH",
            url_image: "https://ih1.redbubble.net/image.565893629.7574/st,small,845x845-pad,1000x1000,f8f8f8.u2.jpg"
          },
          {
            description: "Iota",
            acronym: "IOT",
            url_image: "https://dl.airtable.com/qU3WA8l7RNugSz7XGaNn_large_a2d0a422b38e8427adb36450d17e69f1_11156357cf86_t.png"
          },
          {
            description: "ZCash",
            acronym: "ZEC",
            url_image: "https://s2.coinmarketcap.com/static/img/coins/200x200/1437.png"
          }
        ]

      coins.each do |coin|
          Coin.find_or_create_by!(coin)
      end
    end
  end

  desc "Cadastra os tipos de mineração"
  task add_mining_types: :environment do
    show_spinner("Cadastrando Tipos de Mineração...") do
      mining_types =[
        {description: "Proof of Work", acronym: "PoW"},
        {description: "Proof of Stake", acronym: "PoS"},
        {description: "Proof of Capacity", acronym: "PoC"}
      ]
      mining_types.each do |mining_type|
        MiningType.find_or_create_by!(mining_type)
      end
    end
  end

  private

  def show_spinner(msg_start, msg_end = "(Concluído com sucesso!)")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end
