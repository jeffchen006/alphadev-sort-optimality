# n=5 model=out iset=I1 prefix14_class=9929
cmp P1, P3
cmovg S0, P1
mov S1, P2
cmovge P1, P3
cmovle S0, P3
mov S2, S0
cmp P2, P0
cmovl P2, P0
cmovl P0, S1
cmp S2, P2
cmovle S2, P2
cmovle P2, S0
cmp P0, P1
cmovle S2, P0
