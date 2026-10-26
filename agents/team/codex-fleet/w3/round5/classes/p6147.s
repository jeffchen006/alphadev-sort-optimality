# n=5 model=out iset=I1 prefix14_class=6147
cmp P3, P2
mov S1, P2
cmovle P2, P3
cmovg S1, P3
mov S2, P1
cmp P0, S2
cmovge P1, P0
mov S0, P1
cmovg P0, S2
cmp S0, S1
cmovg S0, S1
cmovl P1, S1
mov P1, S0
mov S2, P2
