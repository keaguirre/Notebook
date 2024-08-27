/*

npm install -g typescript
tsc -init para crear el archivo tsconfig.json
buscaremos las siguientes propiedades definiremos los valores o los cambiaremos si es necesario:
"target": "es2016"
"rootDir": "./src"
"outDir": "./dist"
"removeComments": true
"noEmitOnError": false
"sourceMap": true
"noUnusedParameters": true,   
"noImplicitReturns": true,
"strictnullChecks": true,
deberemos tener mas menos la siguiente estructura
.
├── dist
│   └── index.js
├── src
│   └── index.ts
└── tsconfig.json

Para mas detalles del tsconfig.json ver /Assets/typescript/tsconfig.json

create en debug item -> launch.json file -> debugger Node.js al final creara una carpeta .vscode y dentro el archivo launch.json
luego debajo de "program": "${workspaceFolder}/src/index.ts" agregamos
preLaunchTask": "tsc: build - tsconfig.json",

tipos de JS
number, string, boolean, null, undefined, object, symbol, bigint
tipos de TS
any, void, never, unknown, null, undefined, object, symbol, bigint, arrays, tuplas, Enums= tipo enumerado, lista de constantes que podemos referenciar en el futuro 
tipos inferidos -> infiere que tipo de variable es, si inicializamos el valor, este inferira el tipo, si no se inicializa el valor, se le asignara el tipo any

en ts los miles y millones se pueden separar por guiones bajos
let oneMillion:number = 1_000_000;
*/

let extincionDinosaurios: number = 76_000_000;
let disnoaurioFavorito: string = 'T-rex'
let extintos = 1;

function chanchitoFeliz(config: Object): Object {
    return config
}

let animales: string[] = ['chanchito', 'feliz', 'pollo']
let nums: number[] = [1, 2, 3]
let numsAny = []//ejemplo de any
let checks: boolean [] = []
let nums2: Array<number> = []//Forma secundaria de declarar un array

//animales.map(animal => console.log(animal)) //autocompletado tiene metodos del tipo del dato
//tupla -> es una variable que tiene un set de datos ordenados, no existen en js pero si en ts
let tupla = [1, ['chanchitoFeliz', 'chanchitoPollo']] //tipo de dato or 
tupla.push(22) //no deberia permitirlo pero lo hace

//Enums
const chica = 's'
const mediana = 'm'
const grande = 'l'
const extragrande = 'xl'
enum Tallas {
    Chica='s', Mediana='m', Grande='l', Extragrande='xl' 
}
const variable1: Tallas = Tallas.Chica
//si inicializamos un valor numerico, los siguientes valores se incrementan en 1
//pero si inicializamos un valor con string se requerira un valor para los siguientes

const enum LoadingState { Idle, Loading, Success, Error } 
/* si definimos enum como const no se creara un objeto en js sino que se reemplazara por el valor de la variable lo cual es mas eficiente
siempre y cuando no necesitemos el objeto y definamos el valor de la variable usando el enum */
const estado = LoadingState.Success

const objeto: {
    readonly id:number, //readonly id:number -> no se puede modificar
    nombre:string //si queremos que nombre sea opcional puede ser nombre?:string
    talla: Tallas
} = { id:1, nombre:'', talla:Tallas.Chica }  

//objeto.id = "2" //no lo permite, a menos que en el obj agregue una propiedad string con '' o "texto"

/* Otra forma mas practica de definir un obj es mediante la definicion de tipos */
type Direccion = {
    direccion: {
        numero: number,
        calle: string,
        direccion: string
    }
}
type Persona = {
    id:number,
    nombre:string,
    talla:Tallas
    direccion: {
        numero: number,
        calle: string,
        direccion: string
    }
}

const objeto2: Persona = { 
    id: 1,
    nombre: '',
    talla: Tallas.Chica, 
    direccion: { numero: 1,
        calle: 'calle',
        direccion: 'direccion'
    }
}

const arr: Persona[] = [] //inicializamos un array de objetos de tipo Persona vacio

//funciones

let fn1 = () => {}
function fn2 (){}

const  fn: ()=> number = () => { //fn: (params) => void definimos el tipo de retorno de la funcion 
    let x = 2
    if (x > 5) {
        return 7
    }else{//sin el else no permitiria retornar un valor porque seria 'undefined' o 'void' el cual no es asignable al tipo de retorno
        return 4
    }
    return 2 //Si no queremos usar else podemos retornar un valor por defecto lo cual es valido para el tipo
}

const fn3: (a:number) => string = (edad:number) => { //primero definimos que recibiremos un argumento tipo number, luego con => definimos el tipo de retorno y luego definimos el nombre del argumento que recibiremos
    if (edad > 18)
        return 'puedes pasar'
    return 'no puedes pasar'
}

function validadEdad(edad:number, msg:string = 'txt mensaje'):string{//podemos dejar un valor inicializado o por defecto en los parametro ej: msg:string = 'txt mensaje' | spara el retorno de las funciones definidas como function podemos definir el tipo de retorno al final de la funcion: function validadEdad(edad:number):string{}
    if (edad > 18)
        return 'puedes pasar ' + msg
    return 'no puedes pasar'
    
}
validadEdad(22, 'hola');

//tipo never cuando una funcion nunca retorna un valor y queremos definir esto de manera explicita por ej funciones que lanzan excepciones
//si ponemos retorno void y no retornamos nada, no permitira retornar un valor como undefined
function ErrorUsuario():never{
    throw new Error('Error')
}

//Tipos avanzados

//Union types
let puntaje:number | string = 98 //sirve para definir mas de un tipo de dato en caso de ser necesario
puntaje = 'hola mundo'

type Animal = {
    id:number,
    estado: string
}
type Usuario = {
    id:number,
    name:string
}

let animal: Usuario | Animal = { id: 1, estado: '', name: '' }

//union types functions
function sumaDos (n: number | string): number {
    if (typeof n === 'number') {
        return n + 2
    }//si definimos este bloque de validacion, asumira que el otro bloque es un string
    return parseInt(n)+2
    //si no defino una validacion, me muestra los metodos que tienen en comun los tipos de datos
}
sumaDos('2')

//intersection types
type Audit = {
    created_at: string,
    modified_at: string,
}

type Product = {
    name: string,
}

const product: Audit & Product = {
    created_at: '',
    modified_at: '',
    name: ''
}
//intersection types toma las propiedades de ambos tipos de datos y las une en un solo objeto

//literal types para definir valores especificos
const nDeFibo: 0 | 1 | 2 | 3 | 5 = 3; //definicion en la variable
type Fibo = 0 | 1 | 2 | 3 | 5
const nDeFibo2: Fibo = 0; //definicion usando un type

//valores nulos
function toNumber(s:string | null | undefined): number {
    if (!s){
        return 0
    }
    return parseInt(s)
}

// const n = toNumber(null)
// const n = toNumber(undefined)
//con esto validamos todos los posibles valores y manejamos los tipos segun lo recibido

//optional chaining operator
function getUser(id: number){
    if(id < 0){
        null
    }
    return {
        id: 1,
        name: 'chanchito feliz',
        created_at: new Date()
    }
}
const user = getUser(-1)//simulamos que este usr no existe en la bbdd
//console.log(user.created_at) //esto lanzaria un error porque user es null y no tiene la propiedad created_at
console.log(user?.created_at) //esto evita el error y retorna undefined si no existe, no puede acceder a la propiedad
const arr1 = null
arr1?.[0] //esto evita el error y retorna undefined si no existe, no puede acceder a la propiedad
const fn5:any = null
fn5?.() //esto evita el error y retorna undefined si no existe, no puede acceder a la propiedad

