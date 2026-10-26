# n=5 model=out iset=I1 prefix14_class=4703
mov S2, P3
cmp P2, P3
cmovle S2, P2
mov S1, P1
cmovg P3, P2
cmp P1, P0
cmovg P1, P0
cmovle S1, P0
cmovge P0, S1
cmp P3, P0
cmovg S1, P3
cmovg P3, P0
cmp P1, S2
cmovge S1, S2
