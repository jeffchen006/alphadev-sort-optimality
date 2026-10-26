# n=5 model=out iset=I1 prefix14_class=13857
mov S2, P3
cmp P3, P1
mov S1, P0
cmovg S2, P1
cmovle P3, P1
cmp P2, S1
cmovle P0, P2
cmovge S1, P2
cmp P3, S1
cmovle P1, S1
cmovle S1, P3
cmovle P3, P1
cmp P0, S2
mov P3, S2
