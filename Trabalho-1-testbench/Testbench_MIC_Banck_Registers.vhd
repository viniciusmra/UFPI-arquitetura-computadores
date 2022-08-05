library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;


----------- Entidade do Testbench -------
ENTITY Testbench_MIC_Banck_Registers IS

END Testbench_MIC_Banck_Registers;

----------- Arquitetura do Testbench -------
Architecture Type_0 OF Testbench_MIC_Banck_Registers IS

CONSTANT Clk_period : time := 40 ns;
SIGNAL Clk_count : integer := 0;

-- Declara��o de sinais (entrada e sa�da) que conectar�o o projeto ao teste
SIGNAL Signal_Reset		: std_logic := '0';
SIGNAL	Signal_Clk		: std_logic := '0';
SIGNAL	Signal_Enc		: std_logic := '0';
SIGNAL	Signal_A_Address	: std_logic_vector(3 DOWNTO 0)  := "0000";
SIGNAL	Signal_B_Address	: std_logic_vector(3 DOWNTO 0)  := "0000";
SIGNAL	Signal_C_Address	: std_logic_vector(3 DOWNTO 0)  := "0000";
SIGNAL	Signal_C_Input	: std_logic_vector(15 DOWNTO 0) := "0000000000000000";
SIGNAL	Signal_A_Output	: std_logic_vector(15 DOWNTO 0) := "0000000000000000";
SIGNAL	Signal_B_Output	: std_logic_vector(15 DOWNTO 0) := "0000000000000000";

-- Declara��o de sinais que definir�o a sa�da esperada quando o projeto for simulado
--SIGNAL Expected_A_Output	: std_logic_vector(15 DOWNTO 0);
--SIGNAL Expected_B_Output	: std_logic_vector(15 DOWNTO 0);

-- Instancia��o do projeto a ser testado
COMPONENT MIC_Banck_Registers IS

PORT	(
	Reset		: IN std_logic;
	Clk		: IN std_logic;
	Enc		: IN std_logic;
	A_Address	: IN std_logic_vector(3 DOWNTO 0);
	B_Address	: IN std_logic_vector(3 DOWNTO 0);
	C_Address	: IN std_logic_vector(3 DOWNTO 0);
	C_Input	: IN std_logic_vector(15 DOWNTO 0);
	A_Output	: OUT std_logic_vector(15 DOWNTO 0);
	B_Output	: OUT std_logic_vector(15 DOWNTO 0));
END COMPONENT;

BEGIN

-- Instancia��o do projeto a ser testado
Dut: MIC_Banck_Registers

PORT MAP (
	Reset		=> Signal_Reset,
	Clk		=> Signal_Clk,
	Enc		=> Signal_Enc,
	A_Address	=> Signal_A_Address,
	B_Address	=> Signal_B_Address,
	C_Address	=> Signal_C_Address,
	C_Input	=> Signal_C_Input,
	A_Output	=> Signal_A_Output,
	B_Output	=> Signal_B_Output
);

-- Processo que define o rel�gio. Faremos um rel�gio de 40 ns
Clock_Process : PROCESS 
  Begin
    Signal_Clk <= '0';
    wait for Clk_period/2;  --for 0.5 ns signal is '0'.
    Signal_Clk  <= '1';
    Clk_count <= Clk_count + 1;
    wait for Clk_period/2;  --for next 0.5 ns signal is '1'.


IF (Clk_count = 34) THEN     
REPORT "Stopping simulkation after 34 cycles";
    	  Wait;       
END IF;

End Process Clock_Process;

-- Processo que define o Reset. Subiremos o sinal de Reset em 10 ns. Manteremos este sinal com valor alto por mais trinta nanos segundo e voltaremos o Reset para zero
Reset_Process : PROCESS 
  Begin
    Signal_Reset <= '0';
    Wait for 10 ns;
    Signal_Reset <= '1';
    Wait for 30 ns;
    Signal_Reset <= '0';
    wait;

End Process Reset_Process;


-- Nosso teste consistira em escritas sucessivas (iniciando com o valor '1') com sucesso (Enc = 1) no banco de registradores, seguindo de tentativas de escrita sem sucesso (Enc = 0). Assim, Enc ter� o valor '0' durante o cilco de Reset e, posteriormente, se manter� em '1' por 16 ciclos. Terminados os testes de escrita, Enc ira para zero at� o final do teste.


Enc_Process : PROCESS 
  Begin
   Signal_Enc <= '0';
    Wait for 40 ns;
    Signal_Enc <= '1';
    Wait for 640 ns;
    Signal_Enc <= '0';
    Wait for 640 ns;
    wait;
End Process Enc_Process;

-- Processo de defini��o de entrada. Durante o teste de escrita, estaremos PC e AC para os barramentos A e B, respectivamente

Input_Process : PROCESS 
  Begin
-- Especifica��o inicial de valores ---
       Signal_A_Address <= "0000"; -- Leitura de PC
       Signal_B_Address <= "0001"; -- Leitura de AC
       Signal_C_Address <= "0000"; -- Escreve em PC
       Signal_C_Input <= "0000000000000000";
       
       wait for 40 ns;
       Signal_C_Input <= "0000000000000001"; 
       Signal_C_Address <= "0000"; -- Escreve '1'em PC
       
       wait for 40 ns;
       Signal_C_Input <= "0000000000000010"; 
       Signal_C_Address <= "0001"; -- Escreve '2'em AC
       
       wait for 40 ns;
       Signal_C_Input <= "0000000000000011"; 
       Signal_C_Address <= "0010"; -- Escreve '3'em SP
       
       wait for 40 ns;
       Signal_C_Input <= "0000000000000100"; 
       Signal_C_Address <= "0011"; -- Escreve '4'em IR
       
       wait for 40 ns;
       Signal_C_Input <= "0000000000000101"; 
       Signal_C_Address <= "0100"; -- Escreve '5'em TIR
       
       wait for 40 ns;
       Signal_C_Input <= "0000000000000110"; 
       Signal_C_Address <= "0101"; -- Escreve '6'em ZERO (tenta)
       
       wait for 40 ns;
       Signal_C_Input <= "0000000000000111"; 
       Signal_C_Address <= "0110"; -- Escreve '7'em +1 (tenta)
       
       wait for 40 ns;
       Signal_C_Input <= "0000000000001000"; 
       Signal_C_Address <= "0111"; -- Escreve '8'em -1 (tenta)       wait 40 ns;
       
       wait for 40 ns;
       Signal_C_Input <= "0000000000001001"; 
       Signal_C_Address <= "1000"; -- Escreve '9'em AMASK (tenta)
       
       wait for 40 ns;
       Signal_C_Input <= "0000000000001010"; 
       Signal_C_Address <= "1001"; -- Escreve '10'em SMASK (tenta)
       
       wait for 40 ns;
       Signal_C_Input <= "0000000000001011"; 
       Signal_C_Address <= "1010"; -- Escreve '11'em A
       
       wait for 40 ns;
       Signal_C_Input <= "0000000000001100"; 
       Signal_C_Address <= "1011"; -- Escreve '12'em B
       
       wait for 40 ns;
       Signal_C_Input <= "0000000000001101"; 
       Signal_C_Address <= "1100"; -- Escreve '13'em C
       
       wait for 40 ns;
       Signal_C_Input <= "0000000000001110"; 
       Signal_C_Address <= "1101"; -- Escreve '14'em D
       
       wait for 40 ns;
       Signal_C_Input <= "0000000000001111"; 
       Signal_C_Address <= "1110"; -- Escreve '15'em E
       
       wait for 40 ns;
       Signal_C_Input <= "0000000000001001"; 
       Signal_C_Address <= "1111"; -- Escreve '9'em F

-- Terminados os 16 ciclos (40 ns cada ciclo) de leitura, todos os registradores ser�o lidos, tanto pelo barramento A quanto pelo barramento B. As leituras iniciar�o do �ltimo registrador escrito (F) para o primeiro (PC


       wait for 40 ns;
       Signal_A_Address <= "1111"; 
       Signal_B_Address <= "1111"; -- Le F
REPORT "A_Address: "  & integer'image(to_integer(unsigned(Signal_A_Address)));
REPORT "A_Output: "  & integer'image(to_integer(unsigned(Signal_A_Output)));
REPORT "B_Address: "  & integer'image(to_integer(unsigned(Signal_B_Address)));
REPORT "B_Output: "  & integer'image(to_integer(unsigned(Signal_B_Output)));
       wait for 40 ns;
       Signal_A_Address <= "1110"; 
       Signal_B_Address <= "1110"; -- Le E
REPORT "A_Address: "  & integer'image(to_integer(unsigned(Signal_A_Address)));
REPORT "A_Output: "  & integer'image(to_integer(unsigned(Signal_A_Output)));
REPORT "B_Address: "  & integer'image(to_integer(unsigned(Signal_B_Address)));
REPORT "B_Output: "  & integer'image(to_integer(unsigned(Signal_B_Output)));
       wait for 40 ns;
       Signal_A_Address <= "1101"; 
       Signal_B_Address <= "1101"; -- Le D
REPORT "A_Address: "  & integer'image(to_integer(unsigned(Signal_A_Address)));
REPORT "A_Output: "  & integer'image(to_integer(unsigned(Signal_A_Output)));
REPORT "B_Address: "  & integer'image(to_integer(unsigned(Signal_B_Address)));
REPORT "B_Output: "  & integer'image(to_integer(unsigned(Signal_B_Output)));
       wait for 40 ns;
       Signal_A_Address <= "1100"; 
       Signal_B_Address <= "1100"; -- Le C
REPORT "A_Address: "  & integer'image(to_integer(unsigned(Signal_A_Address)));
REPORT "A_Output: "  & integer'image(to_integer(unsigned(Signal_A_Output)));
REPORT "B_Address: "  & integer'image(to_integer(unsigned(Signal_B_Address)));
REPORT "B_Output: "  & integer'image(to_integer(unsigned(Signal_B_Output)));
       wait for 40 ns;
       Signal_A_Address <= "1011"; 
       Signal_B_Address <= "1011"; -- Le B
REPORT "A_Address: "  & integer'image(to_integer(unsigned(Signal_A_Address)));
REPORT "A_Output: "  & integer'image(to_integer(unsigned(Signal_A_Output)));
REPORT "B_Address: "  & integer'image(to_integer(unsigned(Signal_B_Address)));
REPORT "B_Output: "  & integer'image(to_integer(unsigned(Signal_B_Output)));       
       wait for 40 ns;
       Signal_A_Address <= "1010"; 
       Signal_B_Address <= "1010"; -- Le A
REPORT "A_Address: "  & integer'image(to_integer(unsigned(Signal_A_Address)));
REPORT "A_Output: "  & integer'image(to_integer(unsigned(Signal_A_Output)));
REPORT "B_Address: "  & integer'image(to_integer(unsigned(Signal_B_Address)));
REPORT "B_Output: "  & integer'image(to_integer(unsigned(Signal_B_Output)));
       wait for 40 ns;
       Signal_A_Address <= "1001"; 
       Signal_B_Address <= "1001"; -- Le SMASK
REPORT "A_Address: "  & integer'image(to_integer(unsigned(Signal_A_Address)));
REPORT "A_Output: "  & integer'image(to_integer(unsigned(Signal_A_Output)));
REPORT "B_Address: "  & integer'image(to_integer(unsigned(Signal_B_Address)));
REPORT "B_Output: "  & integer'image(to_integer(unsigned(Signal_B_Output)));
       wait for 40 ns;
       Signal_A_Address <= "1000"; 
       Signal_B_Address <= "1000"; -- Le AMASK
REPORT "A_Address: "  & integer'image(to_integer(unsigned(Signal_A_Address)));
REPORT "A_Output: "  & integer'image(to_integer(unsigned(Signal_A_Output)));
REPORT "B_Address: "  & integer'image(to_integer(unsigned(Signal_B_Address)));
REPORT "B_Output: "  & integer'image(to_integer(unsigned(Signal_B_Output)));
       wait for 40 ns;
       Signal_A_Address <= "0111"; 
       Signal_B_Address <= "0111"; -- Le -1
REPORT "A_Address: "  & integer'image(to_integer(unsigned(Signal_A_Address)));
REPORT "A_Output: "  & integer'image(to_integer(unsigned(Signal_A_Output)));
REPORT "B_Address: "  & integer'image(to_integer(unsigned(Signal_B_Address)));
REPORT "B_Output: "  & integer'image(to_integer(unsigned(Signal_B_Output)));

       wait for 40 ns;
       Signal_A_Address <= "0110"; 
       Signal_B_Address <= "0110"; -- Le +1
REPORT "A_Address: "  & integer'image(to_integer(unsigned(Signal_A_Address)));
REPORT "A_Output: "  & integer'image(to_integer(unsigned(Signal_A_Output)));
REPORT "B_Address: "  & integer'image(to_integer(unsigned(Signal_B_Address)));
REPORT "B_Output: "  & integer'image(to_integer(unsigned(Signal_B_Output)));

       wait for 40 ns;
       Signal_A_Address <= "0101"; 
       Signal_B_Address <= "0101"; -- Le ZERO
REPORT "A_Address: "  & integer'image(to_integer(unsigned(Signal_A_Address)));
REPORT "A_Output: "  & integer'image(to_integer(unsigned(Signal_A_Output)));
REPORT "B_Address: "  & integer'image(to_integer(unsigned(Signal_B_Address)));
REPORT "B_Output: "  & integer'image(to_integer(unsigned(Signal_B_Output)));

       wait for 40 ns;
       Signal_A_Address <= "0100"; 
       Signal_B_Address <= "0100"; -- Le TIR
REPORT "A_Address: "  & integer'image(to_integer(unsigned(Signal_A_Address)));
REPORT "A_Output: "  & integer'image(to_integer(unsigned(Signal_A_Output)));
REPORT "B_Address: "  & integer'image(to_integer(unsigned(Signal_B_Address)));
REPORT "B_Output: "  & integer'image(to_integer(unsigned(Signal_B_Output)));

       wait for 40 ns;
       Signal_A_Address <= "0011"; 
       Signal_B_Address <= "0011"; -- Le IR
REPORT "A_Address: "  & integer'image(to_integer(unsigned(Signal_A_Address)));
REPORT "A_Output: "  & integer'image(to_integer(unsigned(Signal_A_Output)));
REPORT "B_Address: "  & integer'image(to_integer(unsigned(Signal_B_Address)));
REPORT "B_Output: "  & integer'image(to_integer(unsigned(Signal_B_Output)));

       wait for 40 ns;
       Signal_A_Address <= "0010"; 
       Signal_B_Address <= "0010"; -- Le SP
REPORT "A_Address: "  & integer'image(to_integer(unsigned(Signal_A_Address)));
REPORT "A_Output: "  & integer'image(to_integer(unsigned(Signal_A_Output)));
REPORT "B_Address: "  & integer'image(to_integer(unsigned(Signal_B_Address)));
REPORT "B_Output: "  & integer'image(to_integer(unsigned(Signal_B_Output)));

       wait for 40 ns;
       Signal_A_Address <= "0001"; 
       Signal_B_Address <= "0001"; -- Le AC
REPORT "A_Address: "  & integer'image(to_integer(unsigned(Signal_A_Address)));
REPORT "A_Output: "  & integer'image(to_integer(unsigned(Signal_A_Output)));
REPORT "B_Address: "  & integer'image(to_integer(unsigned(Signal_B_Address)));
REPORT "B_Output: "  & integer'image(to_integer(unsigned(Signal_B_Output)));

       wait for 40 ns;
       Signal_A_Address <= "0000"; 
       Signal_B_Address <= "0000"; -- Le PC
REPORT "A_Address: "  & integer'image(to_integer(unsigned(Signal_A_Address)));
REPORT "A_Output: "  & integer'image(to_integer(unsigned(Signal_A_Output)));
REPORT "B_Address: "  & integer'image(to_integer(unsigned(Signal_B_Address)));
REPORT "B_Output: "  & integer'image(to_integer(unsigned(Signal_B_Output)));

            wait;

End Process Input_Process;



-- Neste Testebench  os valores de sa�da ser�o impressos e n�o verificados (Testbench tipo 0). Isto tamb�m tem objetivo did�tico de mostrar como a impress�o pode ser feita. (Para outras formas e formatos de impress�o pesquisar na literatura em em muitos guias dispon�veis na internet);

-- As subidas do rel�gio ocorrem a cada 20 ns, os registradores s�o escritos na subida do rel�gio, assim, os valores de sa�da ser�o impressos nas subidas do rel�gio (a cada 20 ns. 


-- Printg_Process : Process 
-- Begin

--Wait for 20 ns;


--REPORT "A_Address: "  & integer'image(to_integer(unsigned(Signal_A_Address)));

--REPORT "A_Output: "  & integer'image(to_integer(unsigned(Signal_A_Output)));

--REPORT "B_Address: "  & integer'image(to_integer(unsigned(Signal_B_Address)));
--REPORT "B_Output: "  & integer'image(to_integer(unsigned(Signal_B_Output)));

--REPORT "C_Address: "  & integer'image(to_integer(unsigned(Signal_C_Address)));
--REPORT "C_Input: "  & integer'image(to_integer(unsigned(Signal_A_Address)));




--REPORT "A_Address: "  & integer'image(to_integer(signed(Signal_A_Address)));
--REPORT "A_Output: "  & integer'image(to_integer(signed(Signal_A_Output)));



--     Wait for 10 ns;
 --     ASSERT (Sinal_Sum /= Expected_Sum) 
--              REPORT  "Em 10 ns, Soma identica a Soma esperada!";
--      ASSERT (Sinal_Cout /= Expected_Cout) 
--              REPORT  "Em 10 ns, Carry_Out identico a Carry_Out esperado";
--              SEVERITY FAILURE;
--
--     Wait for 40 ns;
--      ASSERT (Sinal_Sum /= Expected_Sum) 
--              REPORT  "Em 50 ns, Soma identica a Soma esperada!";
--      ASSERT (Sinal_Cout /= Expected_Cout) 
--              REPORT  "Em 50 ns, Carry_Out identico a Carry_Out esperado";
--              
--     Wait for 70 ns;
--      ASSERT (Sinal_Sum /= Expected_Sum) 
--              REPORT  "Em 120 ns, Soma identica a Soma esperada!";
--      ASSERT (Sinal_Cout /= Expected_Cout) 
--              REPORT  "Em 120 ns, Carry_Out identico a Carry_Out esperado";
--
--              SEVERITY FAILURE;

--        IF NOW = 1360 ns THEN     
--    	  ASSERT FALSE
--			REPORT "Simula��o conclu�da com sucesso! em 1360 ns"; 
--            wait;
--             END IF;
                         
--WAIT;
--END process Printg_Process;



END Type_0;
