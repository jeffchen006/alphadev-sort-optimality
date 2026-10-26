# n=5 model=out iset=I1 prefix14_class=5291
mov S1, P1
cmp P1, P3
mov S0, P2
cmovge P1, P3
cmovle S1, P3
cmovl P3, P1
cmp S0, P0
cmovg P2, P0
cmovle S0, P0
cmp P1, P2
cmovle P1, P2
mov S2, P1
cmovge P3, P2
cmp S1, S0
