# n=5 model=out iset=I1 prefix14_class=6789
mov S2, P3
cmp P3, P0
cmovle S2, P0
cmovl P0, P3
mov S0, P1
cmp P1, P2
mov S1, S2
cmovle S0, P2
cmovge P1, P2
cmp S1, S0
cmovg S1, S0
cmovg S0, S2
cmp P1, P0
cmovle P3, P0
