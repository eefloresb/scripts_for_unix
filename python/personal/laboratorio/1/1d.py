#Variables, contenedores de iformación

edad = 42
nombre="Jose Vicente"
apellido="Flores"


edad2 = 25
miVerdaderaEdad=24

print("Mi nombre es")
print(nombre)
print("y tengo")
print(edad)
print("años")

print("Mi nombre es "+nombre+" y tengo "+str(edad)+" años")

print("Mi nombre es",nombre,"y tengo",edad,"años y el doble de mi edad es:",(edad*2),"años")
print("Mi nombre es %s" %nombre)
print("Mi nombre completo es %s %s y mi edad es %d y la mitad de mi edad %d" %(nombre, apellido, edad,edad/2))
