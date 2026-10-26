# n=5 model=out iset=I1 prefix14_class=14324
cmp P2, P3
cmovle S1, P3
cmovle P3, P2
cmovl P2, S1
mov S2, P3
mov S0, P1
cmp P0, S0
cmovge S0, P0
cmovge P0, P1
cmp P3, P0
cmovg P3, P0
cmovle S2, P0
mov P0, S2
mov P1, S0
