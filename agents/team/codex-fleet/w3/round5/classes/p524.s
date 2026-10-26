# n=5 model=out iset=I1 prefix14_class=524
mov S0, P2
cmp S0, P1
cmovg P2, P1
mov S1, P0
cmovg P1, S0
cmp S1, P3
cmovg S1, P3
cmovg P3, P0
mov S0, P1
mov P0, P2
cmp S1, P2
cmovle P0, S1
cmovg P2, S1
cmovl S1, P2
