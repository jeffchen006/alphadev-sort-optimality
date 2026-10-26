# n=5 model=out iset=I1 prefix14_class=7386
cmp P3, P2
cmovle S1, P3
cmovle P3, P2
cmovl P2, S1
mov S0, P0
mov S2, P3
cmp P0, P1
cmovge P0, P1
cmovg P1, S0
cmp P2, P0
cmovge S1, P0
cmovge P0, P2
cmovg P2, S1
mov P2, P0
