# n=5 model=out iset=I1 prefix14_class=9390
mov S1, P3
cmp S1, P0
cmovle P3, P0
cmovg S1, P0
cmp P1, P2
mov S2, P2
cmovle S2, P1
cmovl P1, P2
mov S0, P3
cmp S2, S1
cmovge P0, S2
cmovg S2, S1
cmovg S1, P0
cmp S0, P1
