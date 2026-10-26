# n=5 model=out iset=I1 prefix14_class=10106
mov S2, P1
mov S0, P0
cmp P3, P0
cmovg P0, P3
cmovg P3, S0
cmp P1, P2
cmovge P1, P2
cmovge P2, S2
cmp P0, P2
cmovle S2, P0
cmovle P0, P2
mov S0, P3
cmovl P2, S2
cmp P1, P3
