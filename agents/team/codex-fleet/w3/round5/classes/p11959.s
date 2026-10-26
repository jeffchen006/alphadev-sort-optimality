# n=5 model=out iset=I1 prefix14_class=11959
cmp P3, P2
cmovle S0, P2
cmovg S0, P3
cmovle P2, P3
mov S1, P0
cmp S1, P1
cmovle S1, P1
cmovl P1, P0
cmp S0, S1
mov S2, P2
cmovge P3, S0
cmovg S0, S1
cmovg S1, P3
cmp P2, P1
