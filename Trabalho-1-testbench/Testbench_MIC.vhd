library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

----------- Entidade do Testbench MIC -------
ENTITY Testbench_MIC IS

END Testbench_MIC;

----------- Arquitetura do Testbench MIC -------
Architecture Type_1 OF Testbench_MIC IS

	CONSTANT Clk_period : time := 40 ns;
	SIGNAL Clk_count : integer := 0;

	-- Declaracao de sinais (entrada e saida) que conectarao o projeto ao teste
	SIGNAL Signal_RESET			: std_logic := '0';
	SIGNAL Signal_CLK		    : std_logic := '0';
	SIGNAL Signal_ENC		    : std_logic := '0';
	SIGNAL Signal_AMUX		    : std_logic := '0';
	SIGNAL Signal_ALU		    : std_logic_vector(1 DOWNTO 0) := "00";
	SIGNAL Signal_SH		    : std_logic_vector(1 DOWNTO 0) := "00";
	SIGNAL Signal_A				: std_logic_vector(3 DOWNTO 0) := "0000";
	SIGNAL Signal_B				: std_logic_vector(3 DOWNTO 0) := "0000";
	SIGNAL Signal_C	   			: std_logic_vector(3 DOWNTO 0) := "0000";
	SIGNAL Signal_N		        : std_logic := '0';
	SIGNAL Signal_Z		        : std_logic := '0';
	SIGNAL Signal_MBR 			: std_logic := '0';
	SIGNAL Signal_MAR 			: std_logic := '0';
	SIGNAL Signal_RD 			: std_logic := '0';
	SIGNAL Signal_WR 			: std_logic := '0';
	SIGNAL Signal_MEM_TO_MBR 	: std_logic_vector(15 DOWNTO 0) := "0000000000000000";
	SIGNAL Signal_DATA_OK 		: std_logic := '0';
	SIGNAL Signal_MBR_TO_MEM 	: std_logic_vector(15 DOWNTO 0) := "0000000000000000";
	SIGNAL Signal_MAR_OUTPUT 	: std_logic_vector(11 DOWNTO 0) := "000000000000";
	SIGNAL Signal_RD_OUTPUT 	: std_logic := '0';
	SIGNAL Signal_WR_OUTPUT 	: std_logic := '0';

	-- Sinais criados para verificar o funcionamento do componente
	SIGNAL Signal_A_BUS				: std_logic_vector(15 DOWNTO 0) := "0000000000000000";
	SIGNAL Signal_B_BUS				: std_logic_vector(15 DOWNTO 0) := "0000000000000000";
	SIGNAL Signal_C_BUS				: std_logic_vector(15 DOWNTO 0) := "0000000000000000";

	-- Declaracao de sinais que definirao a saida esperada quando o projeto for simulado
	--BK de registradores
	--SIGNAL Expected_A_Output	: std_logic_vector(15 DOWNTO 0);
	--SIGNAL Expected_B_Output	: std_logic_vector(15 DOWNTO 0)

	COMPONENT PROJETO_MIC IS
		PORT(
			CLK 	: IN STD_LOGIC;
			RESET 	: IN STD_LOGIC;
			AMUX 	: IN STD_LOGIC;
			ALU 	: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			MBR 	: IN STD_LOGIC;
			MAR 	: IN STD_LOGIC;
			RD 		: IN STD_LOGIC;
			WR 		: IN STD_LOGIC;
			ENC 	: IN STD_LOGIC;
			C 		: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			B 		: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			A 		: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			SH 		: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			MEM_TO_MBR 	: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			DATA_OK 	: IN STD_LOGIC;
			MBR_TO_MEM 	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			MAR_OUTPUT 	: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
			RD_OUTPUT 	: OUT STD_LOGIC;
			WR_OUTPUT 	: OUT STD_LOGIC;
			Z 			: OUT STD_LOGIC;
			N 			: OUT STD_LOGIC;
			A_SIGNAL  	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			B_SIGNAL  	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			C_SIGNAL  	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);	
	END COMPONENT;

	BEGIN

	-- Instanciacao do projeto a ser testado
	Dut: PROJETO_MIC

	-- Nessa parte é feita a linkagem entre os sinais do componente e os sinais do testbench
	PORT MAP(
		CLK 	=> Signal_CLK,
		RESET	=> Signal_RESET,
		AMUX	=> Signal_AMUX,
		ALU		=> Signal_ALU,
		MBR		=> Signal_MBR,
		MAR		=> Signal_MAR,
		RD		=> Signal_RD,
		WR		=> Signal_WR,
		ENC		=> Signal_ENC,
		C 		=> Signal_C,
		B		=> Signal_B,
		A		=> Signal_A,
		SH		=> Signal_SH,
		MEM_TO_MBR	=> Signal_MEM_TO_MBR,
		DATA_OK		=> Signal_DATA_OK,
		MBR_TO_MEM	=> Signal_MBR_TO_MEM,
		MAR_OUTPUT	=> Signal_MAR_OUTPUT,
		RD_OUTPUT	=> Signal_RD_OUTPUT,
		WR_OUTPUT	=> Signal_WR_OUTPUT,
		Z			=> Signal_Z,
		N			=> Signal_N,
		A_SIGNAL	=> Signal_A_BUS,
		B_SIGNAL	=> Signal_B_BUS,
		C_SIGNAL	=> Signal_C_BUS
	);

	--FASES DOS PROCESSOS (PROCESS)
	--definir relogios
	Clock_Process : PROCESS 
	BEGIN
		Signal_CLK <= '0';
		wait for Clk_period/2;  --for 0.5 ns signal is '0'.
		Signal_CLK  <= '1';
		Clk_count <= Clk_count + 1;
		wait for Clk_period/2;  --for next 0.5 ns signal is '1'.

		--qual a quantidade de/2 ciclos?

		IF (Clk_count = 50) THEN     
			REPORT "Stopping simulkation after 34 cycles";
			Wait;       
		END IF;
		
	END PROCESS Clock_Process;

	--PROCESSO DO RESET
	-- Processo que define o Reset. Subiremos o sinal de Reset em 10 ns. Manteremos este sinal com valor alto por mais trinta nanos segundo e voltaremos o Reset para zero
	--Reset_Process : PROCESS 
	--BEGIN
	--	Signal_RESET <= '0';
	--	Wait for 10 ns;
	--	Signal_RESET <= '1';
	--	Wait for 20 ns;
	--	Signal_RESET <= '0';
	--	wait;
	--END PROCESS Reset_Process;

	-- Nosso teste consistira em escritas sucessivas (iniciando com o valor '1') com sucesso (Enc = 1) no banco de registradores, seguindo de tentativas de escrita sem sucesso (Enc = 0). Assim, Enc ter� o valor '0' durante o cilco de Reset e, posteriormente, se manter� em '1' por 16 ciclos. Terminados os testes de escrita, Enc ira para zero at� o final do teste.
	--Enc_Process : PROCESS 
	--Begin
	--    Signal_ENC <= '0';
	--    Wait for 40 ns;
	--    Signal_ENC <= '1';
	--    Wait for 640 ns;
	--    Signal_ENC <= '0';
	--    Wait for 640 ns;
	--    wait;
	--End Process Enc_Process;

	Test_Process : PROCESS 
	BEGIN

		-- Ciclo 00
		Signal_RESET <= '1';
		
		Wait for 40 ns; -- 40 ns
		-- Ciclo 01
		Signal_RESET <= '0';
		-- LODD (AC := M[X])
		-- Consideracoes:
		-- > IR inicia com a instrucao 0000000000000011
		-- > A posicao 000000000011 da memoria guarda o valor 0000000000000100

		-- Preparacao do componente para LODD X, onde X = 000000000011
		Signal_MEM_TO_MBR 	<= "0000000000000011"; 	-- instrucao
		Signal_DATA_OK 		<= '1';					-- Habilita leitura de MBR

		Wait for 40 ns; -- 80 ns
		-- Ciclo 02

		Signal_AMUX 		<= '1'; 	-- Com o mbr
		Signal_ALU 			<= "10";	-- Transparencia
		Signal_SH   		<= "00"; 	-- Nao desloca
		Signal_ENC 			<= '1';		-- Habilita escrita no banco de registradores
		Signal_C 			<= "0011";	-- Endereco do registrador: 0011 > IR
		
		Wait for 40 ns; -- Ciclo 03
	    --LOOD (ac:=m[x])
		Signal_ENC 			<= '0';		-- Desabilita escrita no banco de registradores
		Signal_DATA_OK 		<= '0';		-- Desabilita dataok
		
		Signal_B 			<= "0011";	-- Barramento B recebe IR
		Signal_MAR 			<= '1';  	-- Habilita escrita e MAR
		Signal_RD 			<= '1';		-- Habilita leitura da memoria
		
		wait for 40 ns; -- 160 ns
		-- Ciclo 04
		-- Simulação da memória --
		IF Signal_RD_OUTPUT = '1' AND Signal_MAR_OUTPUT = "000000000011" THEN
			Signal_MEM_TO_MBR 	<= "0000000000000100";
			Signal_DATA_OK 		<= '1';
		END IF;
		
		Wait for 40 ns; -- 200 ns -- Ciclo 05:

		Signal_RD 			<= '0';		-- Desabilita o RD
		Signal_DATA_OK 		<= '0';		-- Desabilita o DATA_OK
		Signal_MAR 			<= '0';		-- Desabilita o MAR

		Signal_AMUX 		<= '1'; 	-- Seleciona o  MBR
		Signal_ALU 			<= "10";	-- Transparencia
		Signal_SH   		<= "00"; 	-- Nao desloca
		Signal_ENC 			<= '1';		-- Habilita escrita no banco de registradores
		Signal_C 			<= "0001";	-- Endereco do registrador: 0001 > AC

		wait for 40 ns; -- 240 ns -- Ciclo 06:  
		Signal_A 			<= "0001";	-- Endereco do registrador: 0001 > AC
		Signal_AMUX 		<= '0';		-- Seleciona o  MBR
		Signal_ALU 			<= "10";	-- Transparencia
		Signal_SH 			<= "00";	-- Nao desloca
		Signal_MBR 			<= '1';		-- Habilita escrita no MBR
		Signal_ENC 			<= '0';		-- Desabilita escrita nos registradores
		
		wait for 40 ns; --260 ns -- Ciclo 07:
		Signal_MBR 			<= '0';		-- Desabilita MBR

		REPORT "FIM DO LODD ";

		
		-- INICIO DO STOD (M[X] := AC)
		-- Considerações:
		-- > AC inicia com o valor 0000000000000100
		-- > O valor de AC será gravado na posicao 000000001011 da memoria
		
		Wait for 40 ns; -- Ciclo 08: Zerando MBR_TO_MEM e Inserindo a instrução em MEM _TO_MBR

		-- Zerando MBR_TO_MEM
		Signal_A 			<= "0101"; 	-- Seleciona registrador "0"
		Signal_AMUX 		<= '0'; 	-- Seleciona barramento A
		Signal_ALU 			<= "10";	-- Transparencia
		Signal_SH   		<= "00";
		Signal_ENC	 		<= '0';		-- Desabilita gravação no registrador
		Signal_MBR	 		<= '1';		-- Habilita gravação em MBR

		-- Zerando MAR
		Signal_B 			<= "0101"; 	-- Seleciona registrador "0"
		Signal_MAR	 		<= '1';		-- Habilita gravação em MBR

		-- Inserindo a instrução no registrador IR
		Signal_MEM_TO_MBR	<= "0001000000001011";	-- Instrução
		Signal_DATA_OK 		<= '1';					-- Habilita leitura de MBR
		
		wait for 40 ns; -- Ciclo 09: Gravando MEM_TO_MBR em IR

		Signal_MBR	 		<= '0';		-- Desabilita gravação em MBR
		Signal_MAR	 		<= '0';		-- Desabilita gravação em MBR
		Signal_DATA_OK 		<= '0';		-- Desabilita DATA_OK

		Signal_AMUX 		<= '1'; 	-- Com o mbr
		Signal_ALU 			<= "10";	-- Transparencia
		Signal_SH   		<= "00"; 	-- Nao desloca
		Signal_C 			<= "0011"; 	-- Seleciona IR
		Signal_ENC	 		<= '1';		-- Habilita gravação no registrador

		Wait for 40 ns; -- Ciclo 10: Grava o valor de AC em MBR e o endereço em MAR
		
		Signal_ENC	 		<= '0';		-- Desabilita gravação no banco de registradores

		Signal_A 			<= "0001";	-- Barramento A pega AC
		Signal_AMUX 		<= '0'; 	-- Com o Barramento A
		Signal_ALU 			<= "10";	-- Transparencia
		Signal_SH   		<= "00"; 	-- Nao desloca
		Signal_MBR 			<= '1';		-- Habilita MBR
		Signal_WR 			<= '1';		-- Habilita escrita no MBR

		Signal_B 			<= "0011"; 	-- Seleciona o registrador IR
		Signal_MAR 			<= '1';		-- Habilita gravação em MAR

		wait for 40 ns; -- Ciclo 11: Desabilita a escrita em MAR e MBR
		
		Signal_MAR 			<= '0'; 	-- Desabilita gravação em MAR 
		Signal_MBR 			<= '0';		-- Desabilita MBR
		
		REPORT "FIM DO STOD";
		
		
		-- INICIO DO ADDD (ac := ac + m[x])
		-- Considerações:
		-- > AC inicia com valor 0000000000000100
		-- > O endereço X = 000000011010
		-- > O valor do endereço M[X] = 0000000000000101
		--> O resultado da soma é: 0000000000001001

		wait for 40 ns; -- Ciclo 12: Zerando MBR_TO_MEM e Inserindo a instrução em MEM _TO_MBR

		-- Zerando MBR_TO_MEM
		Signal_A 			<= "0101"; 	-- Seleciona registrador "0"
		Signal_AMUX 		<= '0'; 	-- Seleciona barramento A
		Signal_ALU 			<= "10";	-- Transparencia
		Signal_SH   		<= "00";
		Signal_ENC	 		<= '0';		-- Desabilita gravação no registrador
		Signal_MBR	 		<= '1';		-- Habilita gravação em MBR

		-- Zerando MAR
		Signal_B 			<= "0101"; 	-- Seleciona registrador "0"
		Signal_MAR	 		<= '1';		-- Habilita gravação em MBR

		-- Inserindo a instrução no registrador IR
		Signal_MEM_TO_MBR	<= "0010000000011010"; 	-- Instrução
		Signal_DATA_OK 		<= '1';					-- Habilita leitura de MBR
		
		wait for 40 ns; -- Ciclo 13: Grava MEM_TO_MBR em IR
		
		Signal_MBR	 		<= '0';		-- Habilita gravação em MBR
		Signal_DATA_OK 		<= '0';	    -- Desabilita DATA_OK
		Signal_AMUX 		<= '1'; 	-- Com o mbr
		Signal_ALU 			<= "10";	-- Transparencia
		Signal_SH   		<= "00"; 	-- Nao desloca
		Signal_C 			<= "0011"; 	-- Seleciona IR
		Signal_ENC	 		<= '1';		-- Habilita gravação no registrador

		wait for 40 ns;  -- Ciclo 14: Escreve o endereço em MAR

		Signal_ENC 			<= '0';

		Signal_B 			<= "0011"; 	-- Coloca IR no barramento B
		Signal_MAR			<= '1';		-- Habilita gravação em MAR
		Signal_RD 			<= '1';		-- Habilita a leitura

		wait for 40 ns;  -- Ciclo 15: Simulação da memória

		IF Signal_RD_OUTPUT = '1' AND Signal_MAR_OUTPUT = "000000011010" THEN
			Signal_MEM_TO_MBR 	<= "0000000000000101";
			Signal_DATA_OK 		<= '1';
		END IF;

		wait for 40 ns;  -- Ciclo 16: Faz a soma do conteúdo de MBR com AC
		
		Signal_RD 			<= '0';		-- Desabilita o RD
		Signal_DATA_OK 		<= '0';		-- Desabilita o DATA_OK
		Signal_MAR 			<= '0';		-- Desabilita o MAR

		Signal_B 			<= "0001";	-- Seleciona o registrador AC
		Signal_AMUX 		<= '1'; 	-- seleciona MBR
		Signal_ALU 			<= "00";	-- Soma
		Signal_SH   		<= "00"; 	-- Nao desloca
		Signal_C 			<= "0001"; 	-- Seleciona AC
		Signal_ENC	 		<= '1';		-- Habilita gravação no banco de registradores

		wait for 40 ns;  -- Ciclo 17: Escreve AC em MBR_TO_MEM para verificação
		
		Signal_ENC	 		<= '0';		-- Desabilita gravação no banco de registradores
		Signal_A 			<= "0001";	-- Seleciona AC
		Signal_AMUX 		<= '0'; 	-- Com o A
		Signal_ALU 			<= "10";	-- Transparênia
		Signal_SH 			<= "00";	-- Não desloca
		Signal_MBR 			<= '1'; 	-- Habilita escrita na memória

		REPORT "FIM DO ADDD";
	
		-- INICIO DO SUBD (AC := AC - M[X])
		-- Considerações:
		-- > AC inicia com valor 0000000000001001
		-- > O endereço X = 000000001010
		-- > O valor do endereço M[X] = 0000000000000010
		-- > O valor final de AC deve ser AC = 0000000000000111 

		wait for 40 ns; -- Ciclo 18:

		Signal_MBR 			<= '0'; 	-- Desabilita escrita na memória

		-- Inserindo a instrução no registrador IR
		Signal_MEM_TO_MBR	<= "0011000000001010"; 	-- Instrução
		Signal_DATA_OK 		<= '1';					-- Habilita leitura de MBR

		wait for 40 ns; -- Ciclo 19:

		Signal_AMUX 		<= '1'; 	-- Seleciona MBR
		Signal_ALU 			<= "10";	-- Transparência
		Signal_SH   		<= "00"; 	-- Não desloca
		Signal_C 			<= "0011"; 	-- Seleciona IR
		Signal_ENC			<= '1';		-- Habilita gravação no baco de registradores
		
		-- AC = AC + 1
		wait for 40 ns; -- Ciclo 20:

		Signal_B 			<= "0011";
		Signal_MAR 			<= '1';  	-- Habilita escrita e MAR
		Signal_RD 			<= '1';		-- Habilita leitura da memória
	
		wait for 40 ns; -- Ciclo 21:

		-- Simulação da memória --
		IF Signal_RD_OUTPUT = '1' AND Signal_MAR_OUTPUT = "000000001010" THEN
			Signal_MEM_TO_MBR 	<= "0000000000000010"; -- dois
			Signal_DATA_OK 		<= '1';
		END IF;

		wait for 40 ns; -- Ciclo 22:
		
		Signal_RD 			<= '0';		-- Desabilita o RD
		Signal_DATA_OK 		<= '0';		-- Desabilita o DATA_OK
		Signal_MAR 			<= '0';		-- Desabilita o MAR

		Signal_AMUX 		<= '1'; 	-- Seleciona o MBR
		Signal_ALU 			<= "11";	-- Inverter
		Signal_SH   		<= "00"; 	-- Nao desloca
		Signal_C 			<= "1010"; 	-- Seleciona o registrador A
		Signal_ENC	 		<= '1';		-- Habilita gravação no registrador

		wait for 40 ns; -- Ciclo 23:
		
		Signal_A <= "0001"; 	-- Seleciona o registrador AC
		Signal_B <= "0110";		-- Seleciona o registrador 1
		
		Signal_AMUX <= '0'; 	-- Com o mbr
		Signal_ALU 	<= "00"; 	-- Soma
		Signal_SH   <= "00";	-- Nao desloca
		
		Signal_ENC <= '1';		-- ENC = 1 > habilita gravacao nos registradores
		Signal_C <= "0001";		-- Seleciona registrador AC

		-- 
		wait for 40 ns; -- Ciclo 24:

		Signal_ENC 			<= '0';		-- Desabilita gravacao nos registradores

		Signal_A 			<= "0001";	-- Selecionao valor de AC
		Signal_B 			<= "1010";	-- Selecionao valor de A
		Signal_AMUX 		<= '0'; 	-- Seleciona o MBR
		Signal_ALU 			<= "00";	-- Soma
		Signal_SH   		<= "00"; 	-- Nao desloca
		Signal_C 			<= "0001"; 	-- Seleciona o registrador AC
		Signal_ENC	 		<= '1';		-- Habilita gravação no registrador

		wait for 40 ns;  -- Ciclo 25:

		Signal_ENC	 		<= '0';		-- Desabilita gravação no registrador
		Signal_A 			<= "0001";	-- Selecionao valor de AC
		Signal_AMUX 		<= '0'; 	-- Com o A
		Signal_ALU 			<= "10";	-- Transparenia
		Signal_MBR 			<= '1';		-- Habilita MBR

		wait for 40 ns; -- Ciclo 26:

		Signal_MBR <= '0';

		REPORT "FIM DO SUBD";

		wait for 40 ns;  -- 1040 ns -- Ciclo 27:
		Signal_RESET		<= '1';

		wait for 40 ns;  -- 1060 ns -- Ciclo 28:

		Signal_RESET		<= '0';

		--LOCO (AC:= X; 0<=X<=4095)
		--Descricao: carrega constante
		-- Considerações:
		-- > O valor X = 000000001111
		-- > O valor final de AC deve ser AC = 0000000000001111

		-- Inserindo a instrução no registrador IR
		Signal_MEM_TO_MBR	<= "0111000000001111"; 	-- Instrução
		Signal_DATA_OK 		<= '1';					-- Habilita leitura de MBR
		
		wait for 40 ns;  -- Ciclo 29: Grava a instrução em IR

		Signal_AMUX 		<= '1'; 	-- Seleciona MBR
		Signal_ALU 			<= "10";	-- Transparência
		Signal_SH   		<= "00"; 	-- Não desloca
		Signal_C 			<= "0011"; 	-- Seleciona IR
		Signal_ENC	 		<= '1';		-- Habilita gravação no banco de registradores

		wait for 40 ns;  -- Ciclo 30: Faz a máscara
		
		Signal_B 			<= "0011"; 	-- Coloca IR no barramento B
		Signal_A			<= "1000";	-- Coloca AMASK no barramento A
		Signal_AMUX 		<= '0'; 	-- Seleciona A
		Signal_ALU 			<= "01";	-- Operacao AND
		Signal_C 			<= "0001"; 	-- Seleciona AC
		Signal_ENC	 		<= '1';		-- Habilita gravação no banco de registradores
		
		wait for 40 ns;  -- Ciclo 31: Grava o resultado em MBR para verificação

		Signal_ENC	 		<= '0';		-- Desabilita gravação no banco de registradores
		Signal_MBR			<= '1';		-- Habilita a escrita em MBR

		wait for 40 ns;  -- Ciclo 32: Desabilita escrita em MBR

		Signal_MBR 			<= '0';		-- Desabilita a escrita em MBR

		REPORT "FIM DO LOCO";

		wait for 40 ns;  -- Ciclo 33:

		-- INICIO DA MACROINTRUCAO JNEG
		-- If AC < 0 then PC := X
		-- Descricao: Desvia se AC for negativo
		-- Considerações:
		-- > O valor de X = 000000101101
		-- > O primeiro valor de AC = 0111111111111111
		-- > O Segundo valor de AC = 1000000000000000
	 

		-- Inserindo a instrução no registrador IR
		Signal_MEM_TO_MBR	<= "1100000000101101"; 	-- intrucao
		Signal_DATA_OK 		<= '1';					-- Habilita leitura de MBR
		
		----------------------------- TESTE COM O VALOR DE AC >= 0 ------------------------------

		wait for 40 ns; -- Ciclo 34:
		
		Signal_AMUX 		<= '1'; 	-- Seleciona MBR
		Signal_ALU 			<= "10";	-- Transparência
		Signal_SH   		<= "00"; 	-- Não desloca
		Signal_C 			<= "0011"; 	-- Seleciona IR
		Signal_ENC	 		<= '1';		-- Habilita gravação no registrador

		wait for 40 ns;  -- Ciclo 35: Inserindo a valor no registrador AC

		Signal_MEM_TO_MBR	<= "0111111111111111"; 	-- valor
		Signal_DATA_OK 		<= '1';					-- Habilita leitura de MBR

		wait for 40 ns;  -- Ciclo 36: Gravando o valor em AC

		Signal_AMUX 		<= '1'; 	-- Seleciona MBR
		Signal_ALU 			<= "10";	-- Transparência
		Signal_SH   		<= "00"; 	-- Não desloca
		Signal_C 			<= "0001"; 	-- Seleciona AC
		Signal_ENC	 		<= '1';		-- Habilita gravação no bando de registradores
		
		wait for 40 ns;  -- Ciclo 37: Testa AC na ALU

		Signal_A 			<= "0001"; 	-- Seleciona AC
		Signal_AMUX 		<= '0'; 	-- Seleciona Barramento A
		Signal_ALU 			<= "10";	-- Transparencia
		Signal_ENC	 		<= '0';		-- Desabilita gravação no bando de registradores

		wait for 40 ns;  -- Ciclo 38: Teste condicional

		IF Signal_N = '1' THEN
			--PC := band(ir, amask)
			Signal_A 			<= "0011";	-- Barramento A recebe IR
			Signal_B 			<= "1000";	-- Barramento B recebe AMASK
			Signal_AMUX 		<= '0'; 	-- Seleciona Barramento A
			Signal_ALU 			<= "01";	-- Operacao and
			Signal_C 			<= "0000";	-- Seleciona PC
			Signal_ENC	 		<= '1';		-- Habilita gravação no bando de registradores
		END IF;	
		
		wait for 40 ns; -- Ciclo 39: Escreve PC em MBR para verificação

		Signal_A 			<= "0000"; 	-- Seleciona PC
		Signal_AMUX 		<= '0'; 	-- Seleciona Barramento A
		Signal_ALU 			<= "10";	-- Transparencia
		Signal_ENC	 		<= '0';		-- Desabilita gravação no registrador

		Signal_MBR			<= '1';		-- Habilita a escrita em MBR

		wait for 40 ns;  -- Ciclo 40: Desabilita gravação

		Signal_ENC	 		<= '0';		-- Desabilita gravação no banco de registradores
		Signal_MBR 			<= '0';		-- Desabilita a escrita em MBR

		----------------------------- TESTE COM O VALOR DE AC NEGATIVO ------------------------------

		wait for 40 ns;  -- Ciclo 41: Inserindo a valor no registrador AC

		Signal_MEM_TO_MBR	<= "1000000000000000"; 	
		Signal_DATA_OK 		<= '1';					-- Habilita leitura de MBR

		wait for 40 ns;  -- Ciclo 42: Grava o valor em AC

		Signal_AMUX 		<= '1'; 	-- Seleciona MBR
		Signal_ALU 			<= "10";	-- Transparência
		Signal_SH   		<= "00"; 	-- Não desloca
		Signal_C 			<= "0001"; 	-- Seleciona AC
		Signal_ENC	 		<= '1';		-- Habilita gravação no registrador
		
		wait for 40 ns;  -- Ciclo 43:

		Signal_A 			<= "0001"; 	-- Seleciona AC
		Signal_AMUX 		<= '0'; 	-- Seleciona Barramento A
		Signal_ALU 			<= "10";	-- Transparencia
		Signal_ENC	 		<= '0';		-- Desabilita gravação no registrador

		wait for 40 ns;  -- Ciclo 44:

		IF Signal_N = '1' THEN
			--PC := band(ir, amask)

			Signal_A 			<= "0011";
			Signal_B 			<= "1000";
			Signal_AMUX 		<= '0'; 	-- Seleciona Barramento A
			Signal_ALU 			<= "01";	-- Operacao and
			Signal_C 			<= "0000";
			Signal_ENC	 		<= '1';		-- Habilita gravação no registrado
		END IF;	
		
		wait for 40 ns; -- Ciclo 45:

		Signal_A 			<= "0000"; 	-- Seleciona PC
		Signal_AMUX 		<= '0'; 	-- Seleciona Barramento A
		Signal_ALU 			<= "10";	-- Transparencia
		Signal_ENC	 		<= '0';		-- Desabilita gravação no registrador
		Signal_MBR			<= '1';		-- Habilita a escrita em MBR

		wait for 40 ns;  -- Ciclo 46:

		Signal_ENC	 		<= '0';		-- Habilita gravação no banco de registradores
		Signal_MBR 			<= '0';		-- Desabilita a escrita em MBR

		REPORT "FIM DO JNEG";

		-- INSP (incrementa AC)

		wait;
		
	END PROCESS Test_Process;


END Type_1;