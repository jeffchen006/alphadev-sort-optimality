# n=5 model=out iset=I1 prefix14_class=9303
cmp P1, P3
cmovge S2, P1
cmovg P1, P3
cmovge P3, S2
cmp P2, P0
cmovge S0, P2
cmovle S0, P0
cmovle P0, P2
mov S1, P0
cmp P1, P0
cmovg P0, P1
cmovge P1, S1
cmp P3, S0
cmovl P2, S0
