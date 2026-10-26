# n=5 model=out iset=I1 prefix14_class=9130
mov S0, P2
cmp P2, P3
cmovg S0, P3
cmovl P2, P3
cmp P0, P1
mov S2, P2
cmovge S1, P0
mov P3, S0
cmovge P0, P1
cmovg P1, S1
cmp P0, P3
cmovle S0, P0
cmovle P0, P3
cmovge P3, P0
