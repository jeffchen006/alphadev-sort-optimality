# n=5 model=out iset=I1 prefix14_class=12908
cmp P0, P3
mov S1, P0
cmovge P0, P3
mov S0, P1
cmovle S1, P3
cmp S0, P2
cmovg P1, P2
mov S2, S1
cmovle S0, P2
cmp P1, P0
cmovle P3, P0
cmovl P0, P1
cmovl P1, P3
cmp S0, S2
