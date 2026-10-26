# n=5 model=out iset=I1 prefix14_class=6201
cmp P2, P3
mov S1, P1
cmovle S2, P3
cmovle P3, P2
cmovl P2, S2
cmp P0, S1
cmovg P1, P0
cmovle S1, P0
mov S0, P2
cmp P2, P1
cmovl P2, P1
cmovle P1, S0
cmp S1, P3
cmovge P2, S1
