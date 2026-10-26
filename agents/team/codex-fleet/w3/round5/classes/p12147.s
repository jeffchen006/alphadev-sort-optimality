# n=5 model=out iset=I1 prefix14_class=12147
cmp P0, P1
mov S1, P2
cmovg S0, P1
cmovge P1, P0
cmovg P0, S0
cmp P3, S1
cmovg P2, P3
cmovge P3, S1
cmp P0, P3
cmovg S0, P0
cmovg P0, P3
cmovg P3, S0
cmp P1, P2
cmovl S0, P1
