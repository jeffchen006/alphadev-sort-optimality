# n=5 model=out iset=I1 prefix14_class=13621
mov S1, P2
cmp P3, P0
mov S2, P0
cmovle P0, P3
cmovg S2, P3
cmp P1, P2
cmovg P2, P1
cmovle S1, P1
cmp P0, S1
cmovg P1, S1
cmovge S1, P0
cmovg P0, P1
mov P3, P2
mov P0, S1
