# n=5 model=out iset=I1 prefix14_class=9550
cmp P0, P2
cmovl S0, P2
cmovge S0, P0
mov S1, P1
cmovg P0, P2
cmp S1, P3
cmovge P1, P3
mov S2, P1
cmovle S1, P3
cmp P0, P1
cmovg S2, P0
cmovl P1, P0
cmp S1, S0
cmovg P0, S0
