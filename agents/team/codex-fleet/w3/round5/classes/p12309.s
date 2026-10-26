# n=5 model=out iset=I1 prefix14_class=12309
mov S1, P3
cmp P1, P2
cmovge S0, P2
cmovle S0, P1
cmovl P1, P2
cmp P0, S1
cmovl S1, P0
cmovg P3, P0
cmp S1, S0
cmovge P2, S1
cmovg S1, S0
cmovg S0, P2
cmp P1, P3
mov S1, P1
