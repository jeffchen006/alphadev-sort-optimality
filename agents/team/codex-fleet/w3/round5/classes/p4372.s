# n=5 model=out iset=I1 prefix14_class=4372
cmp P0, P1
mov S0, P2
cmovle S2, P1
cmovle P1, P0
cmovle P0, S2
mov S1, P0
cmp S0, P3
cmovg P2, P3
cmovle S0, P3
mov P3, P2
cmp P2, P1
cmovl P2, P1
cmovg P3, P1
cmovge P1, P2
