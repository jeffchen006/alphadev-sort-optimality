# n=5 model=out iset=I1 prefix14_class=9555
mov S1, P2
cmp P3, P1
cmovle S2, P1
cmovge S2, P3
cmovl P1, P3
cmp P2, P0
cmovl S1, P0
cmovg P2, P0
mov S0, P2
cmp S0, P1
cmovge S0, P1
cmovge P1, P2
cmp S2, S1
cmovle P2, S2
