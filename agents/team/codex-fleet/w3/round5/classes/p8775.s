# n=5 model=out iset=I1 prefix14_class=8775
cmp P0, P3
mov S0, P3
cmovl P3, P0
cmovl P0, S0
mov S2, P1
cmp P2, P1
cmovg S2, P2
cmovle P1, P2
cmp P0, S2
cmovge S0, P0
cmovge P0, S2
cmovge S2, S0
cmp P3, P1
cmovge S0, P3
