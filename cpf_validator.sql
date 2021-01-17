DECLARE
    v_cpf VARCHAR2(15) := :cpf; -- Aceita número de caracteres com e sem separadores já preenchidos
    v_num_cpf VARCHAR2(11);  -- Aceita somente CPF formatado como números
    v_resultado_cpf VARCHAR2(15); -- Armazena o CPF final após o processamento
BEGIN
    v_num_cpf := REGEXP_REPLACE(v_cpf, '(\d)|([^\d])', '\1'); -- Descarta caracteres inválidos, valida quantidade máxima de 11 números e adiciona à variável v_num_cpf

    
    IF LENGTH(v_num_cpf) <> 11 THEN  -- Mesmo sendo números, se for mais ou menos que o obrigatório é descartado
        RAISE VALUE_ERROR;
    END IF;
    
    IF REGEXP_LIKE(v_cpf, '[a-z]', 'i') THEN  -- Melhor seria NOT LIKE  [^\d\-\.], mas não funcionou | Valida se possui letras e retorna erro se sim
        RAISE TOO_MANY_ROWS;
    END IF;
    
    IF v_num_cpf = '00000000000' THEN  -- Estava em dúvida por questão do algorítmo aceitar, mas pesquisei e não aceita esse modelo
        RAISE INVALID_NUMBER;
    ELSIF v_num_cpf = '11111111111' THEN
        RAISE INVALID_NUMBER;
    ELSIF v_num_cpf = '22222222222' THEN
        RAISE INVALID_NUMBER;
    ELSIF v_num_cpf = '33333333333' THEN
        RAISE INVALID_NUMBER;
    ELSIF v_num_cpf = '44444444444' THEN
        RAISE INVALID_NUMBER;
    ELSIF v_num_cpf = '55555555555' THEN
        RAISE INVALID_NUMBER;
    ELSIF v_num_cpf = '66666666666' THEN
        RAISE INVALID_NUMBER;
    ELSIF v_num_cpf = '77777777777' THEN
        RAISE INVALID_NUMBER;
    ELSIF v_num_cpf = '88888888888' THEN
        RAISE INVALID_NUMBER;
    ELSIF v_num_cpf = '99999999999' THEN
        RAISE INVALID_NUMBER;
    END IF;
    DECLARE  -- Onde são realizadas demais verificações
        v_numbers NUMBER := 0;  -- Números do CPF calculados
        v_cpf_1 NUMBER(1);  -- Primeiro dígito verificador
        v_cpf_2 NUMBER(1);  -- Segundo dígito verificador
        v_verificador_1 NUMBER(4); -- Recebe resultado do primeiro dígito verificador
        v_verificador_2 NUMBER(4); -- Recebe resultado do segundo dígito verificador
    BEGIN
        v_cpf_1 := TO_NUMBER(SUBSTR(v_num_cpf, -2, 1));
        v_cpf_2 := TO_NUMBER(SUBSTR(v_num_cpf, -1, 1));
        FOR i IN 1..9
        LOOP
            v_verificador_1 := TO_NUMBER(SUBSTR(v_num_cpf, i, 1));
            v_numbers := ((v_verificador_1 * i) + v_numbers);
        END LOOP;
        v_verificador_1 := v_numbers;
        v_numbers := 0;
        FOR i IN 1..10
        LOOP
            v_verificador_2 := TO_NUMBER(SUBSTR(v_num_cpf, i, 1));
            v_numbers := ((v_verificador_2 * (i - 1)) + v_numbers);
        END LOOP;
        v_verificador_2 := v_numbers;
        v_verificador_1 := MOD(v_verificador_1, 11);
        v_verificador_2 := MOD(v_verificador_2, 11);
        IF v_verificador_1 = 10 THEN
            v_verificador_1 := 0;
        END IF;
        IF v_verificador_2 = 10 THEN
            v_verificador_2 := 0;
        END IF;        
        IF v_verificador_1 <> v_cpf_1 OR v_verificador_2 <> v_cpf_2 THEN  -- Caso não esteja como especificado no cálculo de CPF, retorna INVALID_NUMBER
            RAISE INVALID_NUMBER;
        END IF;
    END;
    
    v_resultado_cpf := REGEXP_REPLACE(v_num_cpf, '(\d\d\d)(\d\d\d)(\d\d\d)(\d\d)', '\1.\2.\3-\4');  -- Ajusta caracteres para modelo desejado na exibição
    DBMS_OUTPUT.PUT_LINE('O CPF informado é válido.');
    DBMS_OUTPUT.PUT_LINE('CPF Informado: ' || v_cpf);
    DBMS_OUTPUT.PUT_LINE('CPF Calculado: ' || v_resultado_cpf);
    
EXCEPTION
    WHEN VALUE_ERROR THEN  -- Ocorre também se inserido valor de comprimento maior no bind
        DBMS_OUTPUT.PUT_LINE('O valor digitado possui a quantidade incorreta de dígitos');
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('Divisão por zero.');
    WHEN INVALID_NUMBER THEN
        DBMS_OUTPUT.PUT_LINE('CPF inválido.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Caracteres inválidos no valor inserido.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro não tratado: ' || SQLERRM);

END;

