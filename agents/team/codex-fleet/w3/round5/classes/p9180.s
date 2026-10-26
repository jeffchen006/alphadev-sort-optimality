# n=5 model=out iset=I1 prefix14_class=9180
mov S0, P2
cmp P1, P2
cmovl S0, P1
cmovge P2, P1
mov S2, P0
cmp P3, S2
cmovle P0, P3
cmovl P3, S2
cmp P0, S0
cmovge S2, P0
cmovge P0, S0
cmovg S0, S2
mov S1, P3
cmp P2, S1
