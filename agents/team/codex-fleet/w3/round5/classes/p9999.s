# n=5 model=out iset=I1 prefix14_class=9999
mov S2, P3
mov S1, P2
cmp S1, P1
cmovle P2, P1
cmovg S1, P1
cmp P0, P3
cmovle S2, P0
cmovl P0, P3
cmp P2, P0
cmovge P3, P0
cmovg P0, P2
cmovg P2, P3
cmp S1, S2
cmovle P1, S1
