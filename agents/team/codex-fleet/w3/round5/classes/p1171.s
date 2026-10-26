# n=5 model=out iset=I1 prefix14_class=1171
cmp P3, P0
mov S0, P3
cmovl P3, P0
cmovle P0, S0
cmp P2, P1
mov S2, P2
cmovle S2, P1
cmovg P2, P1
cmp P3, S2
mov P1, P3
cmovle P1, S2
cmovge P3, S2
cmp P2, P0
cmovl S0, P0
