# Utiliser une image de base Ruby officielle
FROM ruby:3.1.2

# Installer les dépendances pour les gems natifs et Node.js pour le JavaScript
RUN apt-get update -qq && apt-get install -y nodejs npm

# Copier l'application dans le conteneur
WORKDIR /monapp
COPY . /monapp

# Installer les gems
COPY Gemfile /monapp/Gemfile
COPY Gemfile.lock /monapp/Gemfile.lock
RUN bundle install

# Ajouter un script pour démarrer le serveur
CMD ["rails", "server", "-b", "0.0.0.0"]
