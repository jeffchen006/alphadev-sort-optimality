# n=5 model=out iset=I1 prefix14_class=13776
cmp P3, P2
cmovge S1, P3
cmovge P3, P2
cmovge P2, S1
cmp P1, P0
mov S2, P1
cmovge P1, P0
cmovg P0, S2
cmp P2, P0
cmovl S2, P2
mov S0, P3
cmovle P2, P0
cmovl P0, S2
cmp P1, S0
