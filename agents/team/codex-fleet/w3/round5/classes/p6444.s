# n=5 model=out iset=I1 prefix14_class=6444
cmp P1, P2
mov S2, P0
mov S0, P2
cmovle S0, P1
cmovge P2, P1
cmp P3, S2
mov S1, P2
cmovle P0, P3
cmovg S2, P3
cmp S2, P2
cmovl P2, S2
cmovg S1, S2
cmp S0, P0
cmovg S2, S0
