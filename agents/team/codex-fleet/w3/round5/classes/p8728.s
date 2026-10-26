# n=5 model=out iset=I1 prefix14_class=8728
cmp P0, P2
cmovle S1, P2
cmovg S1, P0
cmovge P0, P2
cmp P1, P3
cmovle S2, P1
cmovl P1, P3
cmovle P3, S2
mov P2, P0
mov S0, P1
cmp S1, S0
cmovle P1, S1
cmovg S0, S1
cmp P0, P3
