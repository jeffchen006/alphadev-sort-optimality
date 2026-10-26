# n=5 model=out iset=I1 prefix14_class=9101
mov S1, P0
cmp S1, P3
cmovl P0, P3
cmovg S1, P3
mov S0, P2
cmp P2, P1
cmovge P2, P1
cmovle S0, P1
cmp P2, S1
cmovle P3, P2
mov S2, P0
cmovle P2, S1
cmovle S1, P3
cmp S0, S2
