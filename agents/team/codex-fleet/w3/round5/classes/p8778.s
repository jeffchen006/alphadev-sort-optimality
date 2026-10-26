# n=5 model=out iset=I1 prefix14_class=8778
mov S2, P1
cmp P2, P1
cmovl P1, P2
cmovle P2, S2
mov S0, P3
cmp P0, P3
cmovge S0, P0
cmovle P3, P0
cmp P2, S0
cmovg P0, P2
cmovge P2, S0
cmovg S0, P0
cmp P3, P1
cmovge S2, P3
