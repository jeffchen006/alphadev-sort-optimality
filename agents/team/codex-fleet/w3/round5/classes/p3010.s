# n=5 model=out iset=I1 prefix14_class=3010
cmp P1, P0
cmovle S2, P1
cmovle P1, P0
cmovl P0, S2
mov S0, P3
cmp P3, P2
mov S1, P1
cmovge P3, P2
cmovg P2, S0
cmp S1, P2
cmovge P1, P2
cmovg P2, S1
cmp P3, P0
mov S1, P3
