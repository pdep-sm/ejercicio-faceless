class Usuario{
	const property publicaciones = []
	const property amigos = []
	
	// punto 1
	method espacioOcupado() = publicaciones.map({publicacion => publicacion.tamano()})
	
	// punto 2, 8
	method darMeGusta(publicacion){
		publicacion.darMeGusta(self)
	}
	
	// punto 3
	method masAmistosoQue(usuario) = self.cantidadAmigos() > usuario.cantidadAmigos()
	
	method cantidadAmigos() = amigos.size()
	
	// punto 4 
	method mejoresAmigos() = amigos.filter({amigo => self.esMejorAmigo(amigo)})
	
	method esMejorAmigo(amigo) = publicaciones.all({publicacion => publicacion.puedeSerVistaPor(amigo)}) 
	
	method esAmigoDe(amigo) = amigos.contains(amigo)
	
	//punto 5
	method amigoMasPopular() = amigos.max({amigo => amigo.cantidadDeLikes()})
	
	method cantidadDeMeGusta() = publicaciones.sum({publicacion => publicacion.cantidadMeGusta()})
	
	// punto 6
	method puedeVer(publicacion) = publicacion.puedeSerVistaPor(self)
	
	// punto 7
	method publicar(publicacion, permiso){
		publicacion.permiso(permiso)
		publicaciones.add(publicacion)
	}
}

class Publicacion{
	const property usuariosQueDieronMeGusta = #{}
	const property autor
	var property permiso
	
	constructor(_autor, _permiso){
		autor = _autor
		permiso = _permiso
	}
	
	// punto 1
	method tamano()
	
	// punto 2, 8
	method darMeGusta(usuario){
		if(usuariosQueDieronMeGusta.contains(usuario)){
			throw new PublicacionYaLikeadaException("Ya dio el me gusta a esta publicación")
		}
		
		usuariosQueDieronMeGusta.add(usuario)
	}
	
	method cantidadMeGusta() = usuariosQueDieronMeGusta.size()
	
	// punto 4
	method puedeSerVistaPor(usuario) = permiso.puedeVer(usuario)
}

object foto{
	var property factorConversion = 0.7
}

class Foto inherits Publicacion{
	const property alto
	const property ancho 
	
	constructor(_autor, _permiso,  _alto, _ancho) = super(_autor, _permiso){
		alto = _alto
		ancho = _ancho
	}
	
	// punto 1
	override method tamano() = alto * ancho * foto.factorConversion()
}

class Texto inherits Publicacion{
	const property contenido
	
	constructor(_autor, _permiso, _contenido) = super(_autor, _permiso){
		contenido = _contenido
	}
	
	// punto 1
	override method tamano() = contenido.length()
}

class VideoNormal inherits Publicacion{
	const property duracion
	
	constructor(_autor, _permiso, _duracion) = super(_autor, _permiso){
		duracion = _duracion
	}
	
	// punto 1
	override method tamano() = duracion
}

class VideoHD inherits VideoNormal{
	// punto 2
	override method tamano() = 3 * super()
}

class PrivadoConBlacklist{
	const property blacklist = #{}
	
	method puedeVer(autor, usuario) = not blacklist.contains(usuario)
}

class PrivadoConWhitelist{
	const property whitelist = #{}
	
	method puedeVer(autor, usuario) = whitelist.contains(usuario)
}

object publico{
	method puedeVer(autor, usuario) = true
}

object soloAmigos{
	method puedeVer(autor, usuario) = autor.esAmigoDe(usuario)
}

class PublicacionYaLikeadaException inherits Exception{}
