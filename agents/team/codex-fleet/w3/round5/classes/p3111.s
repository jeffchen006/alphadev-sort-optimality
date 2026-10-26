# n=5 model=out iset=I1 prefix14_class=3111
mov S2, P1
cmp P0, P1
mov S0, P3
cmovl P1, P0
cmovge S2, P0
cmp P2, P3
cmovle S0, P2
cmovge P3, P2
mov P2, P1
cmp P1, S0
cmovle P2, S0
cmovge P1, S0
mov P1, P2
mov S0, S2
