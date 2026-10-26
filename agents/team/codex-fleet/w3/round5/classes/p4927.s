# n=5 model=out iset=I1 prefix14_class=4927
mov S0, P2
cmp P2, P1
cmovle S0, P1
cmovg P2, P1
mov S1, P3
cmp S1, P0
cmovl P3, P0
cmovle P0, S1
cmp P2, P0
mov S1, P2
cmovge P2, P0
cmovge P0, S1
cmp P3, S0
cmovle P1, P3
