# n=5 model=out iset=I1 prefix14_class=11944
mov S2, P0
cmp P0, P2
cmovle S2, P2
cmovle P2, P0
cmp P1, P3
mov S1, P1
cmovle P1, P3
cmovle P3, S1
cmp S2, P1
cmovg S1, S2
cmovge S2, P1
cmovg P1, S1
mov P1, P3
cmp P3, P2
