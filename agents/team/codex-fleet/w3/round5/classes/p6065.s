# n=5 model=out iset=I1 prefix14_class=6065
mov S1, P3
cmp S1, P0
cmovle S1, P0
cmovle P0, P3
cmp P2, P1
cmovle S2, P1
cmovl P1, P2
cmovle P2, S2
cmp S1, P2
cmovle P3, P2
mov S0, P1
cmovge P3, S1
cmovle P2, S1
cmp S0, P0
