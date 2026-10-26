# n=5 model=out iset=I1 prefix14_class=23
mov S1, P0
cmp P3, S1
cmovl P0, P3
cmovle P3, S1
mov S2, P0
cmp P1, P2
mov S0, P1
cmovge P1, P2
cmovg P2, S0
cmp P0, P1
cmovle S2, P1
cmovg P0, P1
mov P1, P2
cmp P2, P3
