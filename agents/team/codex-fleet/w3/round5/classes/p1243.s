# n=5 model=out iset=I1 prefix14_class=1243
mov S1, P2
cmp P1, S1
cmovg P2, P1
mov S2, P0
cmovle S1, P1
cmp P3, S2
cmovl P0, P3
cmovg S2, P3
cmp S2, P2
cmovg P3, P2
cmovge P2, S2
mov S0, S1
cmovle P3, S2
cmp S1, P0
