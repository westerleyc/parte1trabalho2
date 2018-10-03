/*Westerley Carvalho Oliveira - 65255

Primeira parte - Trabalho 2

Fazer o diagrama de uma máquina de estados para contador com uma entrada de A de 2 bits. A saida 
deve ser out=0,1,2,0,1,2 quando A=0,  out= 3,2,4,3,2,4 quando A=1, out=1,3,2,3,1,3,2,3 quando A=2 e 
out=5,6,3,5,6,3, ...quando A=3. Desenhar o diagrama com http://asciiflow.com/ ou outro editor ASCII e 
colocar no seu código Verilog com CASE. Escrever um testbench para testar usando seu numero de matricula.
Se for 82322, converter para binario 10100000110010010, depois usar para alimentar A de 2 em 2,
A = 1,1,0,0,1,2,1,0,2. Proietar com memória e implementar em Verilog. Projetar com portas lógicas 
também. O testbench deve executar nas três implementações com mesmo resultado. Usar aplicativo de mapa 
de karnaugh ou executável como https://pyeda.readthedocs.io/en/latest/2llm.html para gerar as equações 
minimizadas.


DIAGRAMA DE ESTADOS

    +---------------------------------------+
    |                                       |
    |   +-------------------------------------------------------------------+
    |   |                                   |                               |
    |   |                          +--------+----+                          |               
+----------------------------------+A=1ou3  A=2  <---+                      |
|   |   |                          |      6      |   |                      |
|   |   |                          |     110     |   |                      |               OBSERVAÇÕES
|   |   |                          |      A=0    +----------+               |
|   |   |                          +------+------+   |      |               |               Os proximos estados indeterminados foram preenchidos
|   |   |                                 |          |      |               |               com o primeiro estado da sequencia gerada pelo A correspondente.
|   |   |   +-----------------------------------------------------------+   |               
|   |   |   |                             |          |      |           |   |               A=0 -> 0,1,2,0,1,2,0,1,2,0,1,2,0,1,2,0,1,2...
|   |   |   |                             |          |      |           |   |               A=1 -> 3,2,4,3,2,4,3,2,4,3,2,4,3,2,4,3,2,4...
|   | +-+---v-------+              +------v------+   |      |   +-------+---v-+             A=2 -> 1,3,2,3,1,3,2,3,1,3,2,3,1,3,2,3,1,3...
|   | | A=2      A=0+-------------->      0      <--------------+A=0    A=1   |             A=3 -> 5,6,3,5,6,3,5,6,3,5,6,3,5,6,3,5,6,3...
|   | |      2      |    +--------->     000     <--------+ |   |      3_     |
| +---+A=1  010     |    |   +-----+A=0ou2       |   |    | |   |     111     |             Os estados foram nomeados como:
| | | |          A=3+------+ |     |A=1 A=3      |   | +--------+A=3      A=2 |
| | | +^------^-----+    | | |     +-+---+-^-----+   | |  | |   +---------+---+             zero / 0 / 000
| | |  |      |          | | |       |   | |         | |  | |             |                 one / 1 / 001
| | |  |      +-------+  | | |       |   | |         | |  | |             |                 two / 2 / 010
| | |  |              |  | | |       |   | |         | |  | | +-----------+                 three / 3 / 011
| | |  |              |  | | |   +---+   | |         | |  | | |                             four / 4 / 100
| | | ++------------+ |  | | |   | +-----v-+-----+   | |  | | | +-------------+             five / 5 / 101
| | | |A=1ou2    A=0+----+ +------->       A=0   <-----+  +-----+A=0          |             six / 6 / 110
+----->      3   A=3+-------------->      5      <--------------+A=3   4      |             three_ / 3_ / 111
  | | |     011     | |      |   | |     101     |   |      | | |     100     |
  | | |             <------------+ |A=1  A=2  A=3+---+      | | |A=2 A=1      |             Note que o estado 3_ é necessario pois a saída igual a 3 aparece 2 vezes na
  | | +------^-^--^-+ |      |     ++----+-^-----+          | | ++-^-+--------+             sequencia para A=2
  | |        | |  |   |      |      |    | |                | |  | | |
  | |        | |  +-----------------+    | |                | |  | | |                      O testbench devia ser montado usando o número de matícula em binário:
  | |        | +--------------------+    | |                | |  | | |                      (65255) em binário é (11 11 11 10 11 10 01 11) o que produz a sequência
  | |        |        |      |      |    | |                | |  | | |
  | |        |        |      |     ++----v-+-----+          | |  | | |                      A=3,3,3,2,3,2,1,3
  | |        |        |      +----->A=1ou2 A=3   <---------------+ | |
  | |        |        |            |      1      |          | |    | |
  | +------------------------------>     001     <------------+    | |
  |          |        +------------+A=0          <----------+      | |
  |          |                     +-------------+                 | |
  +----------------------------------------------------------------+ |
             |                                                       |
             +-------------------------------------------------------+

*/

module flipflop(data,c,r,q);
    input data, c, r;
    output q;
    reg q;
    always @(posedge c or negedge r) begin
        if(r == 1'b0)
            q <= 1'b0; 
        else q <= data; 
    end 
endmodule  


module highlevel(clk, reset, a, s);
    input clk, reset;
    input[1:0] a;
    output[2:0] s;

    reg[2:0] e; //estado atual
    
    parameter[2:0]  zero    = 3'b000,
                    one     = 3'b001,
                    two     = 3'b010,
                    three   = 3'b011,
                    four    = 3'b100,
                    five    = 3'b101,
                    six     = 3'b110,
                    three_  = 3'b111;

    //Logica da saida
    assign s = (e == zero)? 3'd0:
           (e == one)? 3'd1:
           (e == two)? 3'd2:
           (e == three)? 3'd3:
           (e == four)? 3'd4:
           (e == five)? 3'd5:
           (e == six)? 3'd6:3'd3;

    //Logica do proximo estado
    always @(posedge clk or negedge reset) begin
        if(reset == 0)
            e = 0;
        else case(e)
            zero:
                if(a == 2'd3)
                    e = five;
                else if(a == 2'd1) 
                    e = three;
                else e = one;
            one:
                if(a == 2'd3)
                    e = five;
                else if(a == 2'd0) 
                    e = two;
                else e = three;
            two:
                if(a == 2'd3)
                    e = five;
                else if(a == 2'd2) 
                    e = three_;
                else if(a == 2'd1)
                    e = four;
                else e = zero;
            three:
                if(a == 2'd3)
                    e = five;
                else if(a == 2'd0) 
                    e = zero;
                else e = two;
            four:
                if(a == 2'd3)
                    e = five;
                else if(a == 2'd2) 
                    e = one;
                else if(a == 2'd1)
                    e = three;
                else e = zero;
            five:
                if(a == 2'd3)
                    e = six;
                else if(a == 2'd2) 
                    e = one;
                else if(a == 2'd1)
                    e = three;
                else e = zero;
            six:
                if(a == 2'd2)
                    e = one;
                else if (a == 2'd0) 
                    e = zero;
                else e = three;
            three_:
                if(a == 2'd3)
                    e = five;
                else if(a == 2'd2) 
                    e = one;
                else if(a == 2'd1)
                    e = two;
                else e = zero;
        endcase         
    end    
endmodule

module memory(clk, reset, a, s);
    input clk, reset;
    input [1:0] a;
    output [2:0] s;

    reg [5:0] StateMachine [0:31];

    initial begin  
        StateMachine[0] = 6'b001000;  StateMachine[1] = 6'b011000;
        StateMachine[2] = 6'b001000;  StateMachine[3] = 6'b101000;
        StateMachine[4] = 6'b010001;  StateMachine[5] = 6'b011001;
        StateMachine[6] = 6'b011001;  StateMachine[7] = 6'b101001;
        StateMachine[8] = 6'b000010;  StateMachine[9] = 6'b100010;
        StateMachine[10] = 6'b111010;  StateMachine[11] = 6'b101010;
        StateMachine[12] = 6'b000011;  StateMachine[13] = 6'b010011;
        StateMachine[14] = 6'b010011;  StateMachine[15] = 6'b101011;
        StateMachine[16] = 6'b000100;  StateMachine[17] = 6'b011100;
        StateMachine[18] = 6'b001100;  StateMachine[19] = 6'b101100;
        StateMachine[20] = 6'b000101;  StateMachine[21] = 6'b011101;
        StateMachine[22] = 6'b001101;  StateMachine[23] = 6'b110101;
        StateMachine[24] = 6'b000110;  StateMachine[25] = 6'b011110;
        StateMachine[26] = 6'b001110;  StateMachine[27] = 6'b011110;
        StateMachine[28] = 6'b000011;  StateMachine[29] = 6'b010011;
        StateMachine[30] = 6'b001011;  StateMachine[31] = 6'b101011;
    end

    wire [4:0] address; // 32 linhas , 5 bits de endereco
    wire [5:0] dout;  // 6 bits de largura

    assign address[0] = a[0];
    assign address[1] = a[1];
    assign dout = StateMachine[address];
    assign s = dout[2:0];

    flipflop e0(dout[3],clk,reset,address[2]);
    flipflop e1(dout[4],clk,reset,address[3]);
    flipflop e2(dout[5],clk,reset,address[4]);

endmodule

module logicgates(clk, reset, a, s);
    input clk, reset;
    input [1:0] a;
    output [2:0] s;
    wire [2:0] e; 
    wire [2:0] p;
    assign s[0] = e[0];
    assign s[1] = e[1];
    assign s[2] = e[2]&~e[1] | e[2]&~e[0];  
    assign p[0] = ~e[0]&a[1] | ~e[2]&~e[1]&~e[0] | ~e[1]&~a[1]&a[0] | ~e[2]&~e[1]&a[1] | e[1]&a[1]&a[0] | e[2]&~e[0]&a[0] | e[2]&a[1]&~a[0];
    assign p[1] = ~e[1]&~a[1]&a[0] | e[0]&~a[1]&a[0] | ~e[2]&~e[1]&e[0]&~a[0] | ~e[2]&e[1]&a[1]&~a[0] | e[2]&~e[1]&e[0]&a[0] | e[2]&e[1]&~e[0]&a[0];
    assign p[2] = ~e[1]&a[1]&a[0] | e[0]&a[1]&a[0] | ~e[2]&e[1]&~e[0]&a[0] | ~e[2]&e[1]&~e[0]&a[1];
    //total de operadores = 

    flipflop  e0(p[0],clk,reset,e[0]);
    flipflop  e1(p[1],clk,reset,e[1]);
    flipflop  e2(p[2],clk,reset,e[2]);
endmodule  

module main;
    reg clk,reset;
    reg [1:0]a;
    wire [2:0] s;
    wire [2:0] s1;
    wire [2:0] s2;

    highlevel FSM(clk,reset,a,s);
    memory FSM1(clk,reset,a,s1);
    logicgates FSM2(clk,reset,a,s2);

    initial
        clk = 1'b0;
    always
        clk = #(1) ~clk;

    // visualizar formas de onda usar gtkwave out.vcd
    initial  begin
        $dumpfile ("out.vcd"); 
        $dumpvars; 
    end 

    initial 
        begin
        $monitor($time," Clock: %b Reset: %b A: %d CASE: %d MEM: %d PORTAS: %d",clk,reset,a,s,s1,s2);
        #1 reset=0; a=2'd0;
        #1 reset=1;
        #10 a=2'd3; // depois de 5 "clocks", cada clock 2 unidades de tempo
        #10 a=2'd3;
        #10 a=2'd3;
        #10 a=2'd2;
        #10 a=2'd3;
        #10 a=2'd2;
        #10 a=2'd1;
        #10 a=2'd3;
        #10;
        $finish ;
        end
endmodule

