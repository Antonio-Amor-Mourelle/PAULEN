#include "generacion.h"

/**********************************************************************************/

void escribir_cabecera_compatibilidad(FILE* fpasm) {
    /* FUNCIÓN PARA PODER HACER EL CÓDIGO MULTIPLATAFORMA U OTROS PARÁMETROS GENERALES TAL VEZ SE PUEDA QUEDAR VACÍA */
}

/**********************************************************************************/

void escribir_subseccion_data(FILE* fpasm) {
    /* FUNCIÓN PARA ESCRIBIR LA SECCIÓN .data:
            MENSAJES GENERALES (TEXTOS)
            VARIABLES AUXILIARES NECESARIAS EN EL COMPILADOR QUE DEBAN TENER UN VALOR CONCRETO */
    /* Variables auxiliares para mensajes de errores en tiempo de ejecución */
    fprintf(fpasm, "segment .data\n");
    fprintf(fpasm, "msg_error_division db \"ERROR: DIVISON BY ZERO\", 0\n");
}

/**********************************************************************************/
void escribir_cabecera_bss(FILE* fpasm) {
    /* FUNCIÓN PARA ESCRIBIR EL INICIO DE LA SECCIÓN .bss:
            AL MENOS HAY QUE DECLARAR LA VARIABLE AUXILIAR PARA GUARDAR EL PUNTERO DE PILA __esp
     */
    fprintf(fpasm, "segment .bss\n");
    fprintf(fpasm, "\t__esp resd 1\n");
}

/**********************************************************************************/
void declarar_variable(FILE* fpasm, char * nombre, int tipo, int tamano)
/* tipo no hace falta porque para nosotros todo es entero en esta versión, se deja por compatibilidad con futuras versiones*/ {
    /* GENERA EL CÓDIGO ASOCIADO EN LA SECCIÓN .bss PARA DECLARAR UNA VARIABLE CON
            SU NOMBRE (HAY QUE PRECEDER DE _)
            EL TAMANO (1 PARA VARIABLES QUE NO SEAN VECTORES O SU TAMANO EN OTRO CASO )
            TIPO NOSOTROS USAREMOS ESTE AÑO ENTERO O BOOLEANO
     */

    fprintf(fpasm, "\t_%s resd %d\n", nombre, tamano);
}

/************************************************************************************/

void escribir_segmento_codigo(FILE* fpasm) {
    /* ESCRIBE EL INICIO DE LA SECCIÓN DE CÓDIGO
            DECLARACIONES DE FUNCIONES QUE SE TOMARAN DE OTROS MODULOS
            DECLARACION DE main COMO ETIQUETA VISIBLE DESDE EL EXTERIOR
     */
    fprintf(fpasm, "segment .text\n");
    fprintf(fpasm, "\tglobal main\n");
    fprintf(fpasm, "\textern scan_int, print_int, scan_float, print_float\n");
    fprintf(fpasm, "\textern scan_boolean, print_boolean\n");
    fprintf(fpasm, "\textern print_endofline, print_blank, print_string\n");
    fprintf(fpasm, "\textern alfa_malloc, alfa_free, ld_float\n\t");

}

/**********************************************************************************/

void escribir_inicio_main(FILE* fpasm) {
    /* ESCRIBE EL PRINCIPIO DEL CÓDIGO PROPIAMENTE DICHO
            ETIQUETA DE INICIO
            SALVAGUARDA DEL PUNTERO DE PILA (esp) EN LA VARIABLE A TAL EFECTO (__esp)

     */
    fprintf(fpasm, "\nmain:\n");
    fprintf(fpasm, "\tmov dword [__esp], esp\n");
}

/**********************************************************************************/

void escribir_fin(FILE* fpasm) {
    /* ESCRITURA DEL FINAL DEL PROGRAMA
            GESTIÓN DE ERROR EN TIEMPO DE EJECUCIÓN (DIVISION POR 0)
            RESTAURACION DEL PUNTERO DE PILA A PARTIR DE LA VARIABLE __esp
            SENTENCIA DE RETORNO DEL PROGRAMA
     */
    fprintf(fpasm, "\tmov dword esp, [__esp]\n");
    fprintf(fpasm, "\tret\n");
    fprintf(fpasm, "gestion_error_div_cero:\n");
    fprintf(fpasm, "\tpush dword msg_error_division\n");
    fprintf(fpasm, "\tcall print_string\n");
    fprintf(fpasm, "\tadd esp, 4\n");
    fprintf(fpasm, "\tcall print_endofline\n");
    fprintf(fpasm, "\tmov dword esp, [__esp]\n");/*ERROR CORREGIDO*/
    fprintf(fpasm, "\tret");
}

/**********************************************************************************/

void escribir_operando(FILE * fpasm, char * nombre, int es_var) {
    /* SE INTRODUCE EL OPERANDO nombre EN LA PILA
            SI ES UNA VARIABLE (es_var == 1) HAY QUE PRECEDER EL NOMBRE DE _
            EN OTRO CASO, SE ESCRIBE TAL CUAL

     */
    if (es_var) {
        fprintf(fpasm, "\tpush dword  _%s \n", nombre);
    } else {
        fprintf(fpasm, "\tpush dword  %s \n", nombre);
    }
}

void asignar(FILE * fpasm, char * nombre, int es_referencia) {
    /* ESCRIBE EL CÓDIGO PARA REALIZAR UNA ASIGNACIÓN DE LO QUE ESTÉ EN LA CIMA DE LA PILA A LA VARIABLE nombre
            SE RECUPERA DE LA PILA LO QUE HAYA POR EJEMPLO EN EL REGISTRO eax
            SI es_referencia == 0 (ES UN VALOR) DIRECTAMENTE SE ASIGNA A LA VARIABLE _nombre
            EN OTRO CASO es_referencia == 1 (ES UNA DIRECCIÓN, UN NOMBRE DE VARIABLE) HAY QUE OBTENER SU VALOR DESREFERENCIANDO
    EL VALOR ES [eax]
     */
    fprintf(fpasm, "\tpop dword eax\n");
    if (es_referencia)
        fprintf(fpasm, "\tmov eax, [eax]\n");
    fprintf(fpasm, "\tmov [_%s], eax\n", nombre);

}

void sumar(FILE * fpasm, int es_referencia_1, int es_referencia_2) {
    /* GENERA EL CÓDIGO PARA SUMAR LO QUE HAYA EN LAS DOS PRIMERAS (DESDE LA CIMA)
    POSICIONES DE LA PILA, TENIENDO EN CUENTA QUE HAY QUE INDICAR SI SON
    REFERENCIAS A VALORES O NO (VER ASIGNAR) ¡¡¡CUIDADO CON EL ORDEN !! EL ARGUMENTO
    QUE SE REFIERE AL SEGUNDO OPERANDO SERÁ EL QUE NOS ENCONTREMOS EN LA PILA PRIMERO

       pop dword eax
       pop dword edx
       add eax, edx
       push dword eax
     */
    fprintf(fpasm, "\tpop dword edx\n");
    fprintf(fpasm, "\tpop dword eax\n");
    if (es_referencia_1)
        fprintf(fpasm, "\tmov eax, dword [eax]\n");
    if (es_referencia_2)
        fprintf(fpasm, "\tmov edx, dword [edx]\n");
    fprintf(fpasm, "\tadd eax, edx\n");
    fprintf(fpasm, "\tpush dword eax\n");

}

void cambiar_signo(FILE * fpasm, int es_referencia) {
    /* GENERA EL CÓDIGO PARA CAMBIAR DE SIGNO LO QUE HAYA EN LA CIMA DE LA PILA
    TENIENDO EN CUENTA QUE PUEDE SER UN VALOR INMEDIATO O UNA REFERENCIA
    A UN VALOR INMEDIATO (VER ASIGNAR)
     */
    fprintf(fpasm, "\tpop dword eax\n");
    if (es_referencia)
        fprintf(fpasm, "\tmov eax, [eax]\n");

    fprintf(fpasm, "\tneg eax\n");
    fprintf(fpasm, "\tpush dword eax\n");

}

void no(FILE * fpasm, int es_referencia, int cuantos_no) {
    /* GENERA EL CÓDIGO PARA NEGAR COMO VALOR LÓGICO LO QUE HAYA EN LA CIMA DE LA PILA
    TENIENDO EN CUENTA QUE PUEDE SER UN VALOR INMEDIATO O UNA REFERENCIA A UN VALOR
    INMEDIATO (VER ASIGNAR)
    COMO ES NECESARIO UTILIZAR ETIQUETAS, SE SUPONE QUE LA VARIABLE cuantos_no ES UN
    CONTADOR QUE ASEGURA QUE UTILIZARLO COMO AÑADIDO AL NOMBRE DE LAS ETIQUETAS QUE
    USEMOS (POR EJEMPLO cierto: O falso: ) NOS ASEGURARÁ QUE CADA LLAMADA A no
    UTILIZA UN JUEGO DE ETIQUETAS ÚNICO

     */


    /* BASICAMENTE HAY QUE GENERAR ESTO
            cmp eax, 0
            je _uno
            push dword 0
            jmp _fin_not
    _uno:   push dword 1
    _fin_not:
     */

    fprintf(fpasm, "\tpop eax\n");
    if (es_referencia)
        fprintf(fpasm, "\t mov eax, [eax]\n");
    fprintf(fpasm, "\tcmp eax, 0\n");

    fprintf(fpasm, "\tje _uno_%d\n", cuantos_no);
    fprintf(fpasm, "\tpush dword 0\n");
    fprintf(fpasm, "\tjmp _fin_negar_%d\n", cuantos_no);
    fprintf(fpasm, "_uno_%d:   push dword 1\n", cuantos_no);
    fprintf(fpasm, "_fin_negar_%d:\n", cuantos_no);

}

void leer(FILE * fpasm, char * nombre, int tipo) {
    /* GENERA EL CÓDIGO PARA LEEER UNA VARIABLE DE NOMBRE nombre Y TIPO tipo (ESTE
    AÑO SÓLO USAREMOS ENTERO Y BOOLEANO) DE CONSOLA LLAMANDO A LAS CORRESPONDIENTES
    FUNCIONES DE ALFALIB (scan_int Y scan_boolean)
     */

    fprintf(fpasm, "\tpush dword _%s\n", nombre);

    if (tipo == INT)
        fprintf(fpasm, "\tcall scan_int\n");
    else
        fprintf(fpasm, "\tcall scan_boolean\n");

    fprintf(fpasm, "\tadd esp, 4\n");


}

void escribir(FILE * fpasm, int es_referencia, int tipo) {
    /* GENERA EL CÓDIGO PARA ESCRIBIR POR PANTALLA LO QUE HAYA EN LA CIMA DE LA PILA
    TENIENDO EN CUENTA QUE PUEDE SER UN VALOR INMEDIATNO (es_referencia == 0) O UNA
    REFERENCIA A UN VALOR INMEDIANTO (es_referencia == 1) Y QUE HAY QUE LLAMAR A LA CORRESPONDIENTE
    FUNCIÓN DE ALFALIB (print_int O print_boolean) DEPENDIENTO DEL TIPO (tipo == BOOLEANO
    O ENTERO )
     */

    fprintf(fpasm, "\tpop eax\n");
    if (es_referencia)
        fprintf(fpasm, "\tmov eax, [eax]\n");
    
    fprintf(fpasm, "\tpush dword eax\n");

    if(tipo == INT)
        fprintf(fpasm, "\tcall print_int\n");
    else
        fprintf(fpasm, "\tcall print_boolean\n");

    fprintf(fpasm, "\tadd esp, 4\n");
    
    fprintf(fpasm, "\tcall print_endofline\n");

}

void restar(FILE * fpasm, int es_referencia_1, int es_referencia_2) {
    /* SIMILAR A SUMAR */
    fprintf(fpasm, "\tpop dword edx\n");
    fprintf(fpasm, "\tpop dword eax\n");
    if (es_referencia_1)
        fprintf(fpasm, "\tmov eax, dword [eax]\n");
    if (es_referencia_2)
        fprintf(fpasm, "\tmov edx, dword [edx]\n");
    fprintf(fpasm, "\tsub eax, edx\n");
    fprintf(fpasm, "\tpush dword eax\n");

}

void multiplicar(FILE * fpasm, int es_referencia_1, int es_referencia_2) {
    /* SIMILAR A SUMAR (CUIDADO CON edx PORQUE LA MULTIPILICACIÓN DEJA EL RESULTADO
    EN edx:eax) */
    /* pop dword eax
       pop dword ebx
       push dword edx ; salvar edx
       imul ebx
       pop dword edx
       push dword eax	Basta no usar edx; no hace falta preservarlo
     */
    /*Sacamos los operandos de la pila*/
    fprintf(fpasm, "\tpop dword ebx\n");
    fprintf(fpasm, "\tpop dword eax\n");
    if (es_referencia_1)
        fprintf(fpasm, "\tmov eax, dword [eax]\n");
    if (es_referencia_2)
        fprintf(fpasm, "\tmov ebx, dword [ebx]\n");

    /*Multiplicacion edx:eax = eax*ebx */
    fprintf(fpasm, "\timul ebx\n");

    /*Restauramos edx, pero no es necesario*/
    //fprintf(fpasm, "pop dword edx\n");

    /*Metemos el resultado en la pila*/
    fprintf(fpasm, "\tpush dword eax\n");




}

void dividir(FILE * fpasm, int es_referencia_1, int es_referencia_2) {
    /* SIMILAR A MULTIPLICAR (CUIDADO CON LA EXTENSIÓN DE SIGNO PREVIA
    QUE IMPLICA EL USO DE edx YA QUE cdq EXTIENDE EL SIGNO A edx:eax)
    Y CUIDADO TAMBIÉN CON CONTROLAR EN TIEMPO DE EJECUCIÓN LA
    DIVISIÓN ENTRE 0 */

    fprintf(fpasm, "\tpop dword ebx\n");
    fprintf(fpasm, "\tpop dword eax\n");

    if (es_referencia_1)
        fprintf(fpasm, "\tmov eax, [eax]\n");

    fprintf(fpasm, "\tcdq\n");

    if (es_referencia_2)
        fprintf(fpasm, "\tmov ebx, [ebx]\n");

    /* Aqui habria que comprobar que ebx o [ebx] no es 0 y saltar
   donde corresponda si lo es */
    fprintf(fpasm, "\tcmp ebx, 0\n");
    fprintf(fpasm, "\tje gestion_error_div_cero\n");

    fprintf(fpasm, "\tidiv ebx\n");

    /* Apilamos unicamente el cociente */
    fprintf(fpasm, "\tpush dword eax\n");

}

void o(FILE * fpasm, int es_referencia_1, int es_referencia_2) {
    /* SIMILAR A SUMAR */
    fprintf(fpasm, "\tpop ebx\n");
    fprintf(fpasm, "\tpop eax\n");

    if (es_referencia_1)
        fprintf(fpasm, "\tmov eax, [eax]\n");
    if (es_referencia_2)
        fprintf(fpasm, "\tmov ebx, [ebx]\n");
     
    fprintf(fpasm, "\tor eax, ebx\n");
    fprintf(fpasm, "\tpush dword eax\n");
}

void y(FILE * fpasm, int es_referencia_1, int es_referencia_2) {
    /* SIMILAR A SUMAR */
    fprintf(fpasm, "\tpop ebx\n");
    fprintf(fpasm, "\tpop eax\n");

    if (es_referencia_1)
        fprintf(fpasm, "\tmov eax, [eax]\n");
    if (es_referencia_2)
        fprintf(fpasm, "\tmov ebx, [ebx]\n");
     
    fprintf(fpasm, "\tand eax, ebx\n");
    fprintf(fpasm, "\tpush dword eax\n");

}

void es_igual(FILE* fpasm, int es_referencia_1, int es_referencia_2, int etiqueta){
    
    fprintf(fpasm, "\tpop dword edx\n");
    fprintf(fpasm, "\tpop dword eax\n");
    if (es_referencia_1)
        fprintf(fpasm, "\tmov eax, dword [eax]\n");
    if (es_referencia_2)
        fprintf(fpasm, "\tmov edx, dword [edx]\n");

    /*Comparacion*/
    fprintf(fpasm, "\tcmp eax, edx\n");
    fprintf(fpasm, "\tjne near no_igual_%d\n", etiqueta);
    fprintf(fpasm, "\tpush dword 1\n");
    fprintf(fpasm, "\tjmp near fin_igual_%d\n", etiqueta);
    fprintf(fpasm, "no_igual_%d:\n", etiqueta);
    fprintf(fpasm, "\tpush dword 0\n");
    fprintf(fpasm, "fin_igual_%d:\n", etiqueta);
    
}


void es_distinto(FILE* fpasm, int es_referencia_1, int es_referencia_2, int etiqueta){
    
    fprintf(fpasm, "\tpop dword edx\n");
    fprintf(fpasm, "\tpop dword eax\n");
    if (es_referencia_1)
        fprintf(fpasm, "\tmov eax, dword [eax]\n");
    if (es_referencia_2)
        fprintf(fpasm, "\tmov edx, dword [edx]\n");

    /*Comparacion*/
    fprintf(fpasm, "\tcmp eax, edx\n");
    fprintf(fpasm, "\tjne near no_igual_%d\n", etiqueta);
    fprintf(fpasm, "\tpush dword 0\n");
    fprintf(fpasm, "\tjmp near fin_igual_%d\n", etiqueta);
    fprintf(fpasm, "no_igual_%d:\n", etiqueta);
    fprintf(fpasm, "\tpush dword 1\n");
    fprintf(fpasm, "fin_igual_%d:\n", etiqueta);

}

void es_menor_o_igual(FILE* fpasm, int es_referencia_1, int es_referencia_2, int etiqueta){	    
    fprintf(fpasm, "\tpop dword edx\n");
    fprintf(fpasm, "\tpop dword eax\n");
    if (es_referencia_1)
        fprintf(fpasm, "\tmov eax, dword [eax]\n");
    if (es_referencia_2)
        fprintf(fpasm, "\tmov edx, dword [edx]\n");

    /*Comparacion*/
    fprintf(fpasm, "\tcmp eax, edx\n");
    fprintf(fpasm, "\tjle near menor_o_igual_%d\n", etiqueta);
    fprintf(fpasm, "\tpush dword 0\n");
    fprintf(fpasm, "\tjmp near fin_menor_o_igual_%d\n", etiqueta);
    fprintf(fpasm, "menor_o_igual_%d:\n", etiqueta);
    fprintf(fpasm, "\tpush dword 1\n");
    fprintf(fpasm, "fin_menor_o_igual_%d:\n", etiqueta);

}
void es_mayor_o_igual(FILE* fpasm, int es_referencia_1, int es_referencia_2, int etiqueta){
    fprintf(fpasm, "\tpop dword edx\n");
    fprintf(fpasm, "\tpop dword eax\n");
    if (es_referencia_1)
        fprintf(fpasm, "\tmov eax, dword [eax]\n");
    if (es_referencia_2)
        fprintf(fpasm, "\tmov edx, dword [edx]\n");

    /*Comparacion*/
    fprintf(fpasm, "\tcmp eax, edx\n");
    fprintf(fpasm, "\tjge near mayor_o_igual_%d\n", etiqueta);
    fprintf(fpasm, "\tpush dword 0\n");
    fprintf(fpasm, "\tjmp near fin_mayor_o_igual_%d\n", etiqueta);
    fprintf(fpasm, "mayor_o_igual_%d:\n", etiqueta);
    fprintf(fpasm, "\tpush dword 1\n");
    fprintf(fpasm, "fin_mayor_o_igual_%d:\n", etiqueta);
}


void es_menor(FILE* fpasm, int es_referencia_1, int es_referencia_2, int etiqueta){
    fprintf(fpasm, "\tpop dword edx\n");
    fprintf(fpasm, "\tpop dword eax\n");
    if (es_referencia_1)
        fprintf(fpasm, "\tmov eax, dword [eax]\n");
    if (es_referencia_2)
        fprintf(fpasm, "\tmov edx, dword [edx]\n");

    /*Comparacion*/
    fprintf(fpasm, "\tcmp eax, edx\n");
    fprintf(fpasm, "\tjl near menor_%d\n", etiqueta);
    fprintf(fpasm, "\tpush dword 0\n");
    fprintf(fpasm, "\tjmp near fin_menor_%d\n", etiqueta);
    fprintf(fpasm, "menor_%d:\n", etiqueta);
    fprintf(fpasm, "\tpush dword 1\n");
    fprintf(fpasm, "fin_menor_%d:\n", etiqueta);
}

void es_mayor(FILE* fpasm, int es_referencia_1, int es_referencia_2, int etiqueta){
    fprintf(fpasm, "\tpop dword edx\n");
    fprintf(fpasm, "\tpop dword eax\n");
    if (es_referencia_1)
        fprintf(fpasm, "\tmov eax, dword [eax]\n");
    if (es_referencia_2)
        fprintf(fpasm, "\tmov edx, dword [edx]\n");

    /*Comparacion*/
    fprintf(fpasm, "\tcmp eax, edx\n");
    fprintf(fpasm, "\tjg near mayor_%d\n", etiqueta);
    fprintf(fpasm, "\tpush dword 0\n");
    fprintf(fpasm, "\tjmp near fin_mayor_%d\n", etiqueta);
    fprintf(fpasm, "mayor_%d:\n", etiqueta);
    fprintf(fpasm, "\tpush dword 1\n");
    fprintf(fpasm, "fin_mayor_%d:\n", etiqueta);
}

void if_then_else(FILE* fpasm, int es_referencia, int etiqueta){    
    fprintf(fpasm, "\tpop dword eax\n");
    if (es_referencia)
        fprintf(fpasm, "\tmov eax, dword [eax]\n");
    fprintf(fpasm, "\tcmp eax, 0\n");
    fprintf(fpasm, "\tje near fin_then_%d\n", etiqueta);
    
}

void fin_then(FILE* fpasm, int etiqueta){
    fprintf(fpasm, "\tjmp near fin_ifelse_%d\n", etiqueta);
    fprintf(fpasm, "fin_then_%d:\n", etiqueta);
    
}

void fin_if_else(FILE* fpasm, int etiqueta){
    fprintf(fpasm, "fin_ifelse_%d:\n", etiqueta);
}




