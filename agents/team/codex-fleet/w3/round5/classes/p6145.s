# n=5 model=out iset=I1 prefix14_class=6145
cmp P3, P0
mov S1, P3
cmovle P3, P0
cmovl P0, S1
cmp P1, P2
mov S1, P2
cmovg S1, P1
cmovge P1, P2
mov S0, S1
cmp S0, P3
cmovle S1, P3
cmovg S0, P3
cmp P0, P1
mov S1, S0
