# n=5 model=out iset=I1 prefix14_class=9684
cmp P0, P3
cmovg S2, P0
cmovle S2, P3
cmovl P3, P0
cmp P1, P2
cmovle P0, P2
cmovle P2, P1
cmovle P1, P0
mov S1, S2
mov S0, P3
cmp S1, P1
cmovge S2, P1
cmovge P1, S1
mov S1, S2
