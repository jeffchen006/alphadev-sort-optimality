# n=5 model=out iset=I1 prefix14_class=5028
mov S0, P1
cmp P2, P1
cmovge S0, P2
cmovle P1, P2
cmp P0, P3
mov S2, P3
cmovl P3, P0
mov P2, S0
cmovle P0, S2
cmp P3, P1
cmovge S1, P1
cmovg P1, P3
cmovge P3, S1
cmp P0, S0
