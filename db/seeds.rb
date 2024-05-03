puts "Cleaning up database..."
Exhibitor.destroy_all
Entreprise.destroy_all
Event.destroy_all
puts "Database cleaned"

organisateur = Entreprise.create(
    name: "Orgnisateur",
    email: "organisateur@dannacode.com",
    website: "www.dannacode.com",
    linkedin: "www.linkdin.com",
    instagram: "www.instagram.com",
    facebook: "www.facebook.com",
    twitter: "www.twiter.com",
    headline: "Technology Service",
    industry: "Technology",
    description: "Le secret pour être millionnaire, et de simplement déléguer ce que nous savons pas faire."
)

file_dannacode = URI.open("https://res.cloudinary.com/dilp6xqmb/image/upload/v1704711578/dannacode-logo.png")
dannacode = Entreprise.create(
    name: "DannaCode",
    email: "christophe.danna@dannacode.com",
    website: "www.dannacode.com",
    linkedin: "www.linkdin.com",
    instagram: "www.instagram.com",
    facebook: "www.facebook.com",
    twitter: "www.twiter.com",
    headline: "Technology Service",
    industry: "Technology",
    description: "Plus grande entreprise de France, vous souhaitez un site d'exeption ? C'est ici et nul part ailleurs !"
)
dannacode.logo.attach(io: file_dannacode, filename: "dannacode.png", content_type: "image?png")

maelcorp = Entreprise.create(
    name: "MaelCorp",
    email: "mael@dannacode.com",
    website: "www.maelcorp.com",
    linkedin: "www.linkdin.com",
    instagram: "www.instagram.com",
    facebook: "www.facebook.com",
    twitter: "www.twiter.com",
    headline: "Technology Service",
    industry: "Technology",
    description: "Plus grande entreprise de France, vous souhaitez un site d'exeption ? C'est ici et nul part ailleurs !"
)
jeux = Event.create(
    title: "Salon de l'agriculture",
    address: "1 Place de la Porte de Versailles",
    city: "Paris",
    country: "France",
    link: "www.cannesticket.com/fr",
    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
    start_time: "2024-04-05",
    end_time: "2024-04-07",
    registration_code: "QWERTY",
    entreprise: organisateur
)

file_play = URI.open("https://res.cloudinary.com/dilp6xqmb/image/upload/v1714567444/FIJ-2024-1024x469_crop9k.jpg")
play = Event.create(
    title: "Festival des jeux",
    address: "17 Rue des Gâtines",
    city: "Paris",
    country: "France",
    link: "www.cannesticket.com/fr",
    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
    start_time: "2024-08-23",
    end_time: "2024-08-25",
    registration_code: "QWERTY",
    entreprise: organisateur
)
play.logo.attach(io: file_play, filename: "festivalDuJeux.png", content_type: "image?png")


file_film = URI.open("https://res.cloudinary.com/dilp6xqmb/image/upload/v1714565721/festival_osfy51.webp")
film = Event.create(
    title: "Festival de Cannes",
    address: "1 Bd de la Croisette",
    city: "Cannes",
    country: "France",
    link: "www.cannesticket.com/fr",
    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
    start_time: "2024-06-23",
    end_time: "2024-06-25",
    registration_code: "QWERTY",
    entreprise: organisateur
)
film.logo.attach(io: file_film, filename: "festival.png", content_type: "image?png")


Exhibitor.create(entreprise: dannacode, event: jeux)
Exhibitor.create(entreprise: maelcorp, event: jeux)
Exhibitor.create(entreprise: dannacode, event: play)
Exhibitor.create(entreprise: maelcorp, event: play)
Exhibitor.create(entreprise: dannacode, event: film)
Exhibitor.create(entreprise: maelcorp, event: film)

puts "finish"