# n=5 model=out iset=I1 prefix14_class=7494
mov S0, P2
cmp S0, P0
mov S1, P1
cmovle S0, P0
cmovge P2, P0
cmp S1, P3
cmovl P1, P3
cmovg S1, P3
mov P0, S1
cmp P2, S1
cmovg S1, P2
cmovl P0, P2
cmp P1, S0
cmovle P0, P1
