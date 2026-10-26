# n=5 model=out iset=I1 prefix14_class=7567
mov S0, P0
cmp P0, P2
cmovg S0, P2
mov S1, P3
cmovge P2, P0
cmp S1, P1
cmovle S1, P1
cmovge P3, P1
cmp P3, S0
cmovle P1, P3
cmovl P3, S0
cmovle S0, P1
cmp S1, P2
cmovl P1, S1
